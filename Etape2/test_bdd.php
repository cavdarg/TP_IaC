<?php
$servername = "data";
$username = "gurcu";
$password = "cavdar58";
$dbname = "mydb";

// Créer une connexion
$conn = new mysqli($servername, $username, $password, $dbname);

// Vérifier la connexion
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}else {
    echo "Connected to MySQL successfully.<br>";
}

// Requête d'insertion
$sql_insert = "INSERT INTO test_table (data) VALUES ('Hello World')";
if ($conn->query($sql_insert) === TRUE) {
    echo "New record created successfully<br>";
} else {
    echo "Error: " . $sql_insert . "<br>" . $conn->error;
}

// Requête de lecture
$sql_read = "SELECT id, data FROM test_table";
$result = $conn->query($sql_read);

if ($result->num_rows > 0) {
    // Afficher les résultats
    while($row = $result->fetch_assoc()) {
        echo "id: " . $row["id"]. " - Data: " . $row["data"]. "<br>";
    }
} else {
    echo "0 results";
}

$conn->close();
?>
