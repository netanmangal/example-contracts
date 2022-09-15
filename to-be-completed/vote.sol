pragma solidity ^0.8.7;

contract cityPoll {
    
    struct City {
        string cityName;
        uint256 vote;
        //you can add city details if you want
    }


    mapping(uint256 => City) public cities; //mapping city Id with the City ctruct - cityId should be uint256
    mapping(address => bool) hasVoted; //mapping to check if the address/account has voted or not

    address owner;
    uint256 public cityCount = 0; // number of city added
    constructor() {
        //TODO set contract caller as owner
        owner = msg.sender;
        //TODO set some intitial cities.
        addCity("Mumbai");
    }
 
 
    function addCity(string memory name_) public {
      //  TODO: add city to the CityStruct
      cities[cityCount] = City({ cityName: name_, vote: 0 });
      cityCount++;
    }
    
    function vote(uint256 id_) public {
        //TODO Vote the selected city through cityID
        require(hasVoted[msg.sender] == false, "You have already voted!!!");
        cities[id_].vote++;
        hasVoted[msg.sender] = true;
    }

    function getCity(uint256 id_) public view returns (string memory) {
        // TODO get the city details through cityID
        return cities[id_].cityName;
    }

    function getVote(uint256 id_) public view returns (uint256) {
        // TODO get the vote of the city with its ID
        return cities[id_].vote;
    }
}
