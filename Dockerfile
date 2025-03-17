 # Use an official Nginx image as the base image
FROM nginx:alpine

# Set the working directory inside the container
WORKDIR /usr/share/nginx/html

# Copy the index.html and adventure.pl files into the Nginx directory
COPY index.html /usr/share/nginx/html/
COPY adventure.pl /usr/share/nginx/html/

# Expose port 80 to allow access to the web server
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]

