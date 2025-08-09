<?php
if (empty($_POST['username']) || empty($_POST['password'])) {
    echo "<pre>Error: Username and password are required.</pre>";
    exit;
}

$raw_username = trim($_POST['username']);
$raw_password = trim($_POST['password']);

// Allow only a-z, A-Z, 0-9, _, -
if (!preg_match('/^[a-zA-Z0-9_-]{3,32}$/', $raw_username)) {
    echo "<pre>Error: Invalid username. Use 3-32 characters: letters, numbers, underscores, or dashes only.</pre>";
    exit;
}

// Check if user already exists (by scanning /etc/passwd)
$passwd = file_get_contents('/etc/passwd');
if (preg_match("/^$raw_username:/m", $passwd)) {
    echo "<pre>Error: Username already exists.</pre>";
    exit;
}

// Encrypt the password using mkpasswd (SHA-512)
$encrypted_password = escapeshellarg(trim(shell_exec("mkpasswd -m sha-512 $raw_password 2>&1")));

if (empty($encrypted_password) || str_contains($encrypted_password, "mkpasswd")) {
    echo "<pre>Error: Failed to encrypt password.</pre>";
    exit;
}

$username = escapeshellarg($raw_username);

// Run adduser script
$cmd = "sudo /usr/local/bin/adduser_web.sh $username $encrypted_password 2>&1";
$output = shell_exec($cmd);

// Send welcome mail
mail(trim($_POST['username']) . "@localhost", "Welcome", "Hello and welcome!");

echo "<pre>User creation output:\n$output</pre>";
?>

