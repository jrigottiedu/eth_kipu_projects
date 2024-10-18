// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// Este contrato es una Subasta

contract Subasta {
    bool subastaFinalizo;
    bool productoVendido;

    // Quien compra y precio
    address public mejorPostor;
    uint256 public mejorApuesta;
    address public immutable VENDEDOR;
    uint256 public constant VALOR_INICIAL = 10000;
    uint256 public immutable tiempoDeFinalizacion;

    // Premio
    uint256 public premio;

    //Se ejecuta una sola vez al momento de desplegar nuestro contrato
    constructor(uint256 tiempoAdicional) {
        // 10 min = 10 * 60
        VENDEDOR = msg.sender; // Address 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        tiempoDeFinalizacion = block.timestamp + tiempoAdicional;
    } // 1728073206 - 60

    //https://www.unixtimestamp.com/ para convertir segundos a una fecha

    function hacerOferta() public payable returns (string memory) {
        if (msg.value > VALOR_INICIAL) {
            mejorApuesta = msg.value;
            mejorPostor = msg.sender;
            for (uint256 i; i < 10; i++) {
                // i = 1
                // Logica del bucle
                premio = premio + 1;
            }
            return "Buena apuesta";
        } else if (msg.value == mejorApuesta) {
            uint256 i;
            while (i < 20) {
                // LOGICA
                i++;
            }

            return "Es la misma, intentalo otra vez";
        } else {
            return "Muy baja la apuesta";
        }
    }
}
