1. Build and run:

   ```bash
   docker build -t php-mail .
   docker run -p 8080:80 --name php-mail --rm --privileged php-mail
   ```

2. Go to: `http://localhost:8080`

3. Submit a username + password.

4. Check the user's mail:

   ```bash
   docker exec -it php-mail su - <username>
   cat Maildir/new/*
   ```


