// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// Librería simple con funciones matemáticas básicas
library MatematicaSimple {
    // Función para verificar si un número es par
    function esPar(uint256 numero) internal pure returns (bool) {
        return numero % 2 == 0;
    }
    
    // Función para duplicar un número
    function duplicar(uint256 numero) internal pure returns (uint256) {
        return numero * 2;
    }
}

// Contrato que usa la librería
contract CalculadoraBasica {
    // Indicamos que queremos usar la librería para variables uint256
    using MatematicaSimple for uint256;
    
    // Función que usa ambas funciones de la librería
    function calcular(uint256 _numero) public pure returns (bool esNumeroPar, uint256 numeroDoble) {
        esNumeroPar = _numero.esPar();    // Usando la primera función de la librería
        numeroDoble = _numero.duplicar();  // Usando la segunda función de la librería
    }
}

