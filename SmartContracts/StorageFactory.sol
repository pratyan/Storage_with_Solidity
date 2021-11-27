pragma solidity ^0.6.0;

//importing 'SimpleStorage' contract
import "./SimpleStorage.sol";

contract StorageFactory {

    //making an dynamic(no length defined) named 'simpleStorageArray' of type 'SimpleStorage'
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        //creating an object named 'simpleStorage', of type 'SimpleStorage'(which is a contract that we imported)
        SimpleStorage simpleStorage = new SimpleStorage();
        //add the newly created object to the array
        simpleStorageArray.push(simpleStorage);
    }

    //function to store to simpleStorage contract
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        //to interact with an contract we need its:
        //address: "address(simpleStorageArray[Index])"
        //ABI

        //geting the contract by the address
        SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        //now, calling the 'store' func from that 'SimpleStorage' conctract
        simpleStorage.store(_simpleStorageNumber);
    }

}
