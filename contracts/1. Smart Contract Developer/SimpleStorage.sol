// SPDX-License-Identifier: MIT
pragma solidity 0.8.18; // First, specify the version of solidity you are goind to use

// our contract
contract SimpleStorage {
    
    uint256 myFavoriteNumber; // default -> 0

    //uint256[] listOfFavoriteNumbers; // [0, 78, 90]

    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    // dynamic array
    Person[] public listOfPeople;

    mapping(string => uint256) public nameToFavoriteNumber;

    // static array
    // Person[3] public listOfPeople3;

    // Person public pat = Person({favoriteNumber: 7, name: "pat"});
    // Person public mariah = Person({favoriteNumber: 16, name: "Mariah"});
    // Person public jon = Person({favoriteNumber: 12, name: "Joe"});

    function store(uint256 _favoriteNumber) public virtual {
        myFavoriteNumber = _favoriteNumber;
    }

    // view, pure -> for non-transactional methods -> just read favoriteNumber
    function retrieve() public view returns(uint256) {
        return myFavoriteNumber; // view -> reading from state
    }
    
    // calldata, memory, storage
    // temporary variables : calldata / memory
    // memory -> can be modified ; calldata -> cannot be modified
    function addPerson(uint256 _favoriteNumber, string memory _name) public {
        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    } 
}

contract SimpleStorage2 {

}

contract SimpleStorage3 {
    
}

contract SimpleStorage4 {

}