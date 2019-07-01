<?php
session_start();
include("functions.php");
$conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
if (isset($_POST['search'])){
  header('Location: sklep.php?found_item='.$_POST['item']);
}
if (isset($_POST['loguj'])) {
   $login = $_POST['login'];
   $haslo = $_POST['haslo'];
   $result = mysqli_query($conn, "SELECT user_id, name, passwd FROM users WHERE email='".$login."';");
   $row = $result->fetch_assoc();
   if (password_verify($haslo, $row["passwd"])) {
     $_SESSION['attempt'] = true;
     $_SESSION['logged'] = true;
     $_SESSION['user'] = $row["name"];
     $_SESSION['user_id'] = $row["user_id"];
     header('Location: panel_klienta.php');
     exit();
   }
   else {
     $_SESSION['logged'] = false;
     $_SESSION['attempt'] = true;
     header('Location: register.php?attempt=1');
     exit();
   }
   mysqli_close($conn);
}
elseif (isset($_GET['completed'])) {
  header('Location: sklep.php?completed=true');
}
elseif (isset($_GET['send_box'])) {
  $_SESSION['payment'] = $_POST['payment'];
  $_SESSION['sender'] = $_POST['sender'];
  header('Location: sklep.php?send_box=true');
}
elseif (isset($_SESSION['quantity']) || isset($_GET['add_box']) ) {
  add_box($_GET['add_box']);
}
elseif (isset($_SESSION['quantity']) || isset($_GET['remove_box']) ) {
  remove_box($_GET['remove_box']);
}
elseif (isset($_GET['complete_box']) ) {
  header('Location: sklep.php?complete_box=true');
}
elseif (isset($_POST['logout']) || isset($_GET['logout'])) {
   $_SESSION['logged'] = false;
   $_SESSION['attempt'] = false;
   $_SESSION['logouted'] = true;
   header('Location: index.php?logout');
   exit();
}
elseif (isset($_POST['register'])) {
  $conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
  $conn->set_charset("utf-8");
  mysqli_query($conn, "SET NAMES utf8");
  mysqli_query($conn, "SET CHARACTER SET utf8");
  mysqli_query($conn, "SET collation_connection = utf8_polish_ci");
  $hash_passwd = password_hash($_POST['haslo'], PASSWORD_DEFAULT);
  mysqli_query($conn, "INSERT INTO users(name, surname, city, street, email, passwd, phone, postcode, created_at) VALUES ('".$_POST['name']."', '".$_POST['surname']."', '".$_POST['city']."', '".$_POST['street']."', '".$_POST['e-mail']."', '".$hash_passwd."', ".$_POST['phone_num'].", '".$_POST['kod_pocztowy']."', NOW())");
  header('Location: register.php?registered=true');
}
?>
