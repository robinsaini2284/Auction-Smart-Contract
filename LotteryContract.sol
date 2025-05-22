// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0<0.9.0;

contract Lottery{

    address public manager;
    address payable[] public players;

    constructor(){
        manager=msg.sender;
    }

    function alreadyEntered() private view returns(bool){
        for(uint i=0;i<players.length;i++){
            if(players[i]==msg.sender) return true;
        }
        return false;
    }

    function enter() payable public {
        require(msg.sender != manager,"manager cannot enter");
        require(alreadyEntered() == false, "Already entered!");
        require(msg.value >=1 ether,"enter amount is less than 0.01 ETH");
        players.push(payable (msg.sender));
    }
    function random() private view returns (uint){
        return uint(sha256(abi.encodePacked(block.difficulty,block.number,players)));
    }

    function pickWinner() public {
        require(manager==msg.sender,"only manager can pick winner");
        uint index=random()% players.length;
        address contractAddress=address(this);
        players[index].transfer(contractAddress.balance);
        players= new address payable[](0);
    }
    function getPlayers() view public returns(address payable[] memory){
        return players;
    }
}