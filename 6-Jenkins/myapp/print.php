<?php
if(isset($_POST['imprimir'])) {
    $nombre = $_POST['nombre'];
    $apellidos = $_POST['apellidos'];
    $fecha_nacimiento = $_POST['fecha_nacimiento'];
    echo "<h2>Detalles</h2>";
    echo "Nombre: $nombre <br>";
    echo "Apellidos: $apellidos <br>";
    echo "Fecha de Nacimiento: $fecha_nacimiento <br>";
}
?>
