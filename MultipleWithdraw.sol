// SPDX-License-Identifier: UNLICENSED.
pragma solidity ^0.8.0;

// En una única transacción distribuir saldos a diferentes address.

contract MultipleWithdraw {

    // Dueño del contrato
    address private owner;

    modifier isOwner() {
        require (msg.sender == owner, "No autorizado: no eres el propietario del contrato.");
        _;
    }


    constructor() {
        owner = msg.sender;
    }


    /*
    @dev    Envía los saldos a diferentes address en una única transacción. 
    
    @param  addresses: Array de direcciones de destino.
    @param  amounts: Array de cantidades a transferir (un saldo por cada dirección)

    @return 
    */
    function multipleWithdraw(address payable[] memory addresses, uint256[] memory amounts) public payable isOwner {

        // La longitud de los dos arrays tiene que ser la misma, ya que es un saldo por cada dirección.
        require(addresses.length == amounts.length, "Los arrays tienen que ser de la misma longitud");

        // Cantidad total enviada en weis.
        uint256 total_amount = 0;

        for (uint256 i = 0; i < amounts.length; i++) {
            // La cantidad total se almacena en weis. 
            // Para ello cada cantidad intermedia se multiplica por "1 wei", y así se convierte dicha cantidad a weis.
            total_amount += amounts[i] * 1 wei; 
        }

        // La suma de todas las cantidades parciales a repartir, tiene que ser igual al valor total enviado para repartir.
        require(total_amount == msg.value, "El valor no coincide");

        // Realizar el pago.
        for (uint256 i = 0; i < addresses.length; i++) {
            // Guardar en weis la cantidad parcial a repartir.
            uint256 receiver_amount = amounts[i] * 1 wei;

            // Enviar esa cantidad a la dirección correspondiente.
            addresses[i].transfer(receiver_amount);
        }

    }


}



