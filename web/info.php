<?php

foreach(get_declared_classes() as $name) {
    if (strpos($name, 'Symfony') !== false) {
        echo $name . "<br/>";
    }
}

foreach(get_declared_interfaces() as $name) {
    if (strpos($name, 'Symfony') !== false) {
        echo $name . "<br/>";
    }
}

phpinfo();