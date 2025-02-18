# Use official Nginx base image
FROM nginx:latest

# Set the working directory
WORKDIR /usr/share/nginx/html

# Copy HTML file to the container's web root
COPY index.html .

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

