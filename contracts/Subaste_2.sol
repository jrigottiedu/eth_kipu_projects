// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// **********************************
// TERMINAR DE VER EL VIDEO DE CLASE
// **********************************

// Este contrato es una Subasta

contract Subasta {
    // Quien compra y precio
    address public mejorPostor; // toma valro 0x00000
    uint256 public mejorApuesta; // toma valor 0
    address payable public immutable VENDEDOR;
    uint256 public constant VALOR_INICIAL = 10000;
    uint256 public immutable tiempoDeFinalizacion;

    // Map - tipo de dato
    // Estructura de datos key-value llave-valor
    mapping(address => uint256) public apostadores;



    // Declaracion de errores
    error Error__NoEresElVendedor();

    // Declaracion de eventos
    event SeHizoUnaApuestaNueva(address mejorPostor, uint256 mejorApuesta);
    event CambioDePrecio(uint256 precioViejo, uint256 nuevoValor);

    //Se ejecuta una sola vez al momento de desplegar nuestro contrato
    constructor(uint256 tiempoAdicional) {
        // 10 min = 10 * 60
        //a msg.sender lo tenemos que hacer payable, porque msg.sender retorna un address
        // pero ese address no es payable.
        VENDEDOR = payable(msg.sender); // Address 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        tiempoDeFinalizacion = block.timestamp + tiempoAdicional;
        mejorApuesta = VALOR_INICIAL; //actualmente 10000
    } // 1728073206 - 60

    //https://www.unixtimestamp.com/ para convertir segundos a una fecha


    // Como recibir Ether
    // 1. Funciones payable
    // 2. receive()
    // 3. fallback()


    receive() external payable {
        hacerOferta();
    }

    // La diferencia es que fallback maneja data
    fallback() external payable { 
        hacerOferta();
    }

    function hacerOferta() public payable {
        // require (condicion, error)
        // si se cumple la condicion el programa sigue, sino retorna error
        require(msg.value > mejorApuesta, "No es suficiente");
        require(msg.sender != mejorPostor, "No puede ser el mismo apostador");
        require(
            block.timestamp < tiempoDeFinalizacion,
            "Ya finalizo la subasta"
        );
        //Logica
        // mejorApuesta = msg.value;
        // mejorPostor = msg.sender;
        apostadores[msg.sender] = msg.value;
        emit SeHizoUnaApuestaNueva(mejorPostor, mejorApuesta);
    }

    // Modifier : es una funcion reutilizable
    // Usos:
    // * restringir
    // * validar entradas o argumentos
    // * revisar condiciones

    modifier soloDueno() {
        if (VENDEDOR != msg.sender) {
            revert Error__NoEresElVendedor();
        }
        _;
     }

    // retirar utiliza el codigo de soloDueno primero
    function retirar() public soloDueno {
        //Hay 3 funciones para transferir Ether
        // 1. send()        - 2300 wei (gas) - retorna un bool
        // 2. transfer()    - 2300 wei (gas) - revert
        // 3. call

        VENDEDOR.transfer(mejorApuesta);

    }

    function cambiarPrecio(uint256 nuevoValor) public soloDueno {
        uint256 precioViejo = mejorApuesta;
        mejorApuesta = nuevoValor;
        emit CambioDePrecio(precioViejo, nuevoValor);
    }
}
