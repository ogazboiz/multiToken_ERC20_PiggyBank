// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;


import "./piggyBank.sol";

 contract piggyUser {
    
    struct piggyDetails {
        string yourPurpose;
        uint deadline;
        address owner;
        string name;
        address piggyContractAddress;

    }
address developerAddress;
    mapping(address => piggyDetails[]) public userPiggyBanks;
    address[] public piggyBanksFactoryAddress;
    mapping(address => uint256) public userCounter;

constructor(){
     developerAddress = msg.sender;
}
   function savingPurpose(string memory _purpose, uint _deadline, string memory _name) public {
 uint256 Counter = userCounter[msg.sender];
  bytes32 salt = keccak256(abi.encodePacked(msg.sender, _purpose, block.timestamp, Counter));
        piggy piggyContract = new piggy{
            salt: salt
        } (
            msg.sender, 
            _purpose,    
            _deadline,
            developerAddress
        );



        require(address(piggyContract) != address(0), "piggy contract deployment failed");
        userPiggyBanks[msg.sender].push(
            piggyDetails({
                yourPurpose: _purpose,
                deadline: _deadline,
                owner: msg.sender,
                name: _name,
                piggyContractAddress: address(piggyContract)
            })
        );
        piggyBanksFactoryAddress.push(address(piggyContract));
        userCounter[msg.sender]++;


   }
   function getUserPiggyBanks(address _user) public view returns (piggyDetails[] memory) {
        return userPiggyBanks[_user];
    }
    function getAllPiggyBanks() public view returns (address[] memory) {
        return piggyBanksFactoryAddress;
    }
    





 }