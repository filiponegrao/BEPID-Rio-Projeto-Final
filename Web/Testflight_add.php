
<?php

 //Conectando com o banco de dados:

 //ESSENCIAIS
$email = $_POST["email"];

$con_string = "host=139.82.24.237 port=5432 dbname=myne user=myne password=vfefrioenlircianmpoanotnenzduemaagcraarovalho";
$query = "INSERT INTO testflight VALUES ('".$email."')";

$conn = pg_connect($con_string);
$result = pg_query($conn, $query);

$modif = pg_affected_rows($result);

// echo ($modif);

?>
