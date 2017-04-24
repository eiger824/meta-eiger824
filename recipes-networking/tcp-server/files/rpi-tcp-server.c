/* A simple server in the internet domain using TCP
   The port number is passed as an argument */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>
#include <errno.h>
#include <getopt.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>

// Will control if log option is enabled. Default: disabled
bool log = false;
const char* logfile = "/var/log/tcp-server/server.log";

// Command list:
const char* commands [] = {
			    "register"	, //register new user
			    "unregister", //unregister user
			    "quit"	, //abort server
			  };

void help(const char* progname)
{
	printf("USAGE: %s [args]\n", progname);
	printf("-h\tShow help and exit\n");
	printf("-l\tLog to file\n");
	printf("-p port\tListen on port\n");
}

void log2file(char* msg)
{
	FILE* file = fopen(logfile, "a");
	if (file == NULL)
	{
		error("ERROR opening file");
		return;
	}
	char outmsg[200];

	time_t curr_time;
	char* c_time_string;
	curr_time = time(NULL);
	c_time_string = ctime(&curr_time);
	c_time_string[strlen(c_time_string) - 1] = '\0';
	strcpy(outmsg, "[");
	strcat(outmsg, c_time_string);
	strcat(outmsg, "] ");
	strcat(outmsg, msg);
	strcat(outmsg, "\n");
	fputs(outmsg, file);
	fclose(file);
}

char* construct(char* msg1, char* msg2)
{
	char *arr = malloc(200);
	if (!arr)
		return NULL;
	strcpy(arr, msg1);
	strcat(arr, ": ");
	strcat(arr, msg2);
	arr[strlen(arr)] = '\0';
	return arr;
}

void error(char *msg)
{
	perror(msg);
	if (log)
		log2file(construct(msg, strerror(errno)));
	exit(1);
}


int main(int argc, char *argv[])
{
	int sockfd, newsockfd, portno, clilen;
	char buffer[256];
	struct sockaddr_in serv_addr, cli_addr;
	int n,c;
	//Default listen port
	portno = 3422;
	while ((c = getopt(argc,argv,"hlp:")) != -1)
	{
		switch(c)
		{
			case 'l':
				printf("Will log to file\n");
				log=true;
			break;
			case 'p':
				portno = atoi(optarg);
				printf("Will listen on custom input port: %d\n",portno);
			break;
			case 'h':
				help(argv[0]);
				exit(0);
			default:
				error("Unknown option");
				help(argv[0]);
				exit(1);
		}
	}

	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockfd < 0) 
		error("ERROR opening socket");
	bzero((char *) &serv_addr, sizeof(serv_addr));

	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = INADDR_ANY;
	serv_addr.sin_port = htons(portno);
	if (bind(sockfd, (struct sockaddr *) &serv_addr,
				sizeof(serv_addr)) < 0) 
		error("ERROR on binding");
	listen(sockfd,5);
	printf("Starting server, listening on port %d ... \n", portno);
	if (log)
		log2file("Starting server, listening on port");
	clilen = sizeof(cli_addr);
	while(1) {
		newsockfd = accept(sockfd, (struct sockaddr *) &cli_addr, &clilen);
		if (newsockfd < 0) 
			error("ERROR on accept");
		bzero(buffer,256);
		n = read(newsockfd,buffer,255);
		if (n < 0) error("ERROR reading from socket");
		buffer[strlen(buffer)-1] = 0;
		printf("Received command: [%s]\n",buffer);
		if (log)
			log2file(construct("Received command:",buffer));

		if (!strcmp(buffer,"quit"))
		{
			close(sockfd);
			printf("Close command received. Closing...\n");
			if (log)
				log2file("Close command received. Closing ...");
			return 0;
		}
		n = write(newsockfd,"OK.",3);
		if (n < 0) error("ERROR writing to socket");
	}
	return 0; 
}
