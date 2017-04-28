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

#include "strutils.h"

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

void logger(char* msg, bool err)
{
	if (err)
	{
		error(msg);
	} else
	{	
		char buf[200];
		strcpy(buf, msg);
		strcat(buf, "\n");
		printf(buf);
	}
	if (log)
		log2file(msg);
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
				logger("Will log to file",0);
				log=true;
			break;
			case 'p':
				portno = atoi(optarg);
				logger(msg_app_int("Will listen on custom input port: %d\n", portno),0);
			break;
			case 'h':
				help(argv[0]);
				exit(0);
			default:
				//error("Unknown option");
				logger("Unknown option",1);
				help(argv[0]);
				exit(1);
		}
	}

	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockfd < 0) 
		logger("ERROR opening socket",1);
	bzero((char *) &serv_addr, sizeof(serv_addr));

	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = INADDR_ANY;
	serv_addr.sin_port = htons(portno);
	if (bind(sockfd, (struct sockaddr *) &serv_addr,
				sizeof(serv_addr)) < 0) 
		logger("ERROR on binding",1);
	listen(sockfd,5);
	logger(msg_app_int("Starting server, listening on port %d ...", portno),0);
	clilen = sizeof(cli_addr);
	while(1) {
		newsockfd = accept(sockfd, (struct sockaddr *) &cli_addr, &clilen);
		if (newsockfd < 0) 
			logger("ERROR on accept",1);
		bzero(buffer,256);
		n = read(newsockfd,buffer,255);
		if (n < 0) logger("ERROR reading from socket",1);
		buffer[strlen(buffer)-1] = 0;
		logger(msg_app_string("Received command: [%s]", buffer), 0);
		//printf("Received command: [%s]\n",buffer);
	
		if (!strcmp(buffer,"quit"))
		{
			close(sockfd);
			logger("Close command received. Closing...", 0);
			return 0;
		}
		else if (!strcmp(buffer,"ping"))
		{
			n = write(newsockfd, "pong", 4);
		}
		else
		{
			n = write(newsockfd,"OK.",3);
		}
		if (n < 0) logger("ERROR writing to socket",1);
	}
	return 0; 
}
