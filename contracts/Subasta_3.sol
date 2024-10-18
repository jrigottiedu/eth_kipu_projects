//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// Este contrato es una Subasta

contract Subasta {
    // ctrl + s => compila
    address public mejorPostor;// 0x00000000000
    uint256 public mejorApuesta;// 0
    address payable public immutable VENDEDOR; // Juan David
    uint256 public constant VALOR_INICIAL = 10000 ;
    uint256 public immutable tiempoDeFinalizacion;

    mapping(address => uint256) public apostadores;

    error Subasta__NoEresElVendedor();

    event SeHizoUnaApuestaNueva(address mejorApostador , uint256 mejorApuesta);
    event CambioDePrecio(uint256 precioViejo,uint256 precioNuevo);


    constructor(uint256 tiempoAdicional) { 
        VENDEDOR = payable(msg.sender); 
        tiempoDeFinalizacion = block.timestamp + tiempoAdicional;
        mejorApuesta = VALOR_INICIAL; 
    }

    receive() external payable { }
 
    fallback() external payable {
        hacerOferta();
    }

    function hacerOferta() public payable  {
        require(msg.value > mejorApuesta,"No es suficiente");
        require(msg.sender != mejorPostor,"No puede ser el mismo");
        require(block.timestamp < tiempoDeFinalizacion, "Paso el tiempo");
        
        if( mejorPostor != address(0) && address(this).balance > 0){
        // address(0) = 0x0000000000000
            payable(mejorPostor).transfer(mejorApuesta);
            apostadores[mejorPostor] = 0;
            // devuelva el monto al dueno anterior
        }
        // 1. Borrar el balance anterior
        // 2. checar cuando mejorPostor == 0


        apostadores[msg.sender] = msg.value;
        mejorApuesta = msg.value;
        mejorPostor = msg.sender;

        emit SeHizoUnaApuestaNueva(msg.sender, mejorApuesta);
        
    }
    

    modifier soloDueno() {
        if(msg.sender != VENDEDOR) {
            revert Subasta__NoEresElVendedor();
        }
        _;
        // logica extra
    }

    function retirar() public soloDueno {
        // 3 funciones para tranfer
        // 1. send()     - 2300 - retorna un bool
        // 2. transfer() - 2300 - revert
        // sumar + 100 gas  = 2250 + 100 - 2300
        // 3. call 
        VENDEDOR.transfer(mejorApuesta);
        //if()
        // address(this).balance = mejorApuesta
    }

    function cambiarPrecio(uint256 nuevoValor) public soloDueno {
        uint256 precioViejo = mejorApuesta;
        mejorApuesta = nuevoValor;
        emit CambioDePrecio(precioViejo, nuevoValor);
    }
}