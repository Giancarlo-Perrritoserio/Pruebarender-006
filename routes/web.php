<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/gean', function () {
    return view('Gean'); // Laravel buscará resources/views/Gean.blade.php
});