#include <stdio.h>
#include <stdlib.h>
#include <string.h>
 
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>

#include <getopt.h>
 
#define BACKLOG 25
 
struct addrinfo* get_server_sockaddr(const char* port)
{
  struct addrinfo hints;
  struct addrinfo* results;
  int retval;
 
  memset(&hints, 0, sizeof(struct addrinfo));
 
  hints.ai_family = AF_INET;        // Return socket addresses for our local IPv4 addresses
  hints.ai_socktype = SOCK_STREAM;  // Return TCP socket addresses
  hints.ai_flags = AI_PASSIVE;      // Socket addresses should be listening sockets
 
  retval = getaddrinfo(NULL, port, &hints, &results);
 
  if (retval != 0)
  {
    fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(retval));
    exit(EXIT_FAILURE);
  }
 
  return results;
}
 
int bind_socket(struct addrinfo* addr_list)
{
  struct addrinfo* addr;
  int sockfd;
  char yes = '1';
 
  // Iterate through each addrinfo in the list; stop when we successfully bind
  // to one
  for (addr = addr_list; addr != NULL; addr = addr->ai_next)
  {
    // Open a socket
    sockfd = socket(addr->ai_family, addr->ai_socktype, addr->ai_protocol);
 
    // Try the next address if we couldn't open a socket
    if (sockfd == -1)
      continue;
 
    // Allow the port to be re-used if currently in the TIME_WAIT state
    if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int)) == -1)
    {
      perror("Unable to set socket option");
      exit(EXIT_FAILURE);
    }
 
    // Try to bind the socket to the address/port
    if (bind(sockfd, addr->ai_addr, addr->ai_addrlen) == -1)
    {
      // If binding fails, close the socket, and try the next address
      close(sockfd);
      continue;
    }
    else
    {
      // Otherwise, we've bound the address/port to the socket, so stop
      // processing
      break;
    }
  }
 
  // Free the memory allocated to the addrinfo list
  freeaddrinfo(addr_list);
 
  // If addr is NULL, we tried every addrinfo and weren't able to bind to any
  if (addr == NULL)
  {
    perror("Unable to bind");
    exit(EXIT_FAILURE);
  }
  else
  {
    // Otherwise, return the socket descriptor
    return sockfd;
  }
 
}
 
int wait_for_connection(int sockfd)
{
  struct sockaddr_in client_addr;            // Remote IP that is connecting to us
  int addr_len = sizeof(struct sockaddr_in); // Length of the remote IP structure
  char ip_address[INET_ADDRSTRLEN];          // Buffer to store human-friendly IP address
  int connectionfd;                          // Socket file descriptor for the new connection
 
  // Wait for a new connection
  connectionfd = accept(sockfd, (struct sockaddr*)&client_addr, &addr_len);
 
  // Make sure the connection was established successfully
  if (connectionfd == -1)
  {
    perror("Unable to accept connection");
    exit(EXIT_FAILURE);
  }
 
  // Convert the connecting IP to a human-friendly form and print it
  inet_ntop(client_addr.sin_family, &client_addr.sin_addr, ip_address, sizeof(ip_address));
  printf("Connection accepted from %s\n", ip_address);
 
  // Return the socket file descriptor for the new connection
  return connectionfd;
}
 
void handle_connection(int connectionfd)
{
  char buffer[4096];
  int bytes_read;
 
  // Read up to 4096 bytes from the client
  bytes_read = recv(connectionfd, buffer, sizeof(buffer), 0);
 
  // If the data was read successfully
  if (bytes_read > 0)
  {
    // Add a terminating NULL character and print the message received
    buffer[bytes_read] = '\0';
    printf("Message received: %s", buffer);
 
    // Echo the data back to the client
    if (send(connectionfd, buffer, bytes_read, 0) == -1)
    {
      perror("Unable to send to socket");
      exit(EXIT_FAILURE);
    }
  }
  else if (bytes_read == -1)
  {
    // Otherwise, if the read failed,
    perror("Unable to read from socket");
    exit(EXIT_FAILURE);
  }
 
  // Close the connection
  close(connectionfd);
}
 
int main(int argc, char** argv)
{
  if(argc>1)
  {
    // We want to listen on port
    struct addrinfo* results = get_server_sockaddr(argv[1]);
   
    // Create a listening socket
    int sockfd = bind_socket(results);
   
    // Start listening on the socket
    if (listen(sockfd, BACKLOG) == -1)
    {
      perror("Unable to listen on socket");
      exit(EXIT_FAILURE);
    }
   
    while (1)
    {
      // Wait for a connection and handle it
      int connectionfd = wait_for_connection(sockfd);
      handle_connection(connectionfd);
    }
  }
  else
    printf("Please provide a port for the connection.\n");
  exit(EXIT_SUCCESS);
}