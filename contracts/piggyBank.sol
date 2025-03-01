// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract piggy {
    //duration ✅ 
    //penalty ✅
    //deposit ✅
    //withraw ✅
    //developerAddress
    // isWithdrawn
    // onlyOwnerModifer
    //supported tokens

    // uint public startTime;
    // uint public endTime;

    
    address developerAddress;
    address owner;
    string public purpose;
    uint public startTime;
    uint public deadline;
    bool isWithdrawn;
    address[3] public supportedToken;
    uint public penaltyPercentage ;

    error Unauthorized();
    error invalidAddress();
    error NotSupported(address);
    error InsufficientFunds();

      modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    mapping(address => mapping(address => uint)) public balances; // user => token => balance
mapping(address => bool) public withdrawnByToken;
    constructor(address _owner,
        string memory _purpose,
        uint  _deadline, address _developerAddress){
            
        owner = _owner;
        purpose = _purpose;
        startTime = block.timestamp;
        deadline = _deadline;
       penaltyPercentage = 15;
       address  USDT = 0xd9145CCE52D386f254917e481eB44e9943F39138;
       address  USDC = 0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d;
       address  DAI = 0x0fC5025C764cE34df352757e82f7B5c4Df39A836;
     supportedToken = [USDT,USDC , DAI ];
     developerAddress =  _developerAddress;
     // 0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005 0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d
    }
    // constructor(address _owner,
    //     string memory _purpose,
    //     uint  _deadline){
    //     supportedToken = [0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,0x5B38Da6a701c568545dCfcB03FcB875f56beddC4];
    //     penaltyPercentage = 15;
    // }

    function deposit(uint _Amount, address _tokenAddress) public returns (bool success) {
                 if( _tokenAddress == address(0)) revert invalidAddress();

                bool isSupported = false;
      
        for (uint i = 0; i < supportedToken.length; i++) {
            // require(IERC20(supportedToken[i]).transferFrom(_reciever, msg.sender, _Amount));
          
           
            if(_tokenAddress ==  supportedToken[i]) {

                isSupported = true;
                break;
                // require(IERC20(_tokenAddress).allowance(msg.sender, address(this)) >= _Amount, "Insufficient allowance");
                // IERC20(_tokenAddress).transferFrom(msg.sender, address(this), _Amount);


                // balances[msg.sender][_tokenAddress] += _Amount;
                
                // return true;    

            }

        }
        // revert NotSupported(_tokenAddress); 

//a better approach
        if (!isSupported) revert NotSupported(_tokenAddress); 

    require(IERC20(_tokenAddress).allowance(msg.sender, address(this)) >= _Amount, "Insufficient allowance");

    IERC20(_tokenAddress).transferFrom(msg.sender, address(this), _Amount);

    balances[owner][_tokenAddress] += _Amount; 

    return true;

            
       


    }

  
// function transfer(address to, uint256 value) external returns (bool);
    function withdraw(address _token) public onlyOwner returns (bool success) {
       require(!withdrawnByToken[_token], "Already withdrawn");
        uint balance = balances[owner][_token];
    
         if (balance == 0) revert InsufficientFunds();

   
        if(block.timestamp >= deadline){

            IERC20(_token).transfer(owner,balance); 
            
        }
        else{
           uint penaltyAmount = (balance * penaltyPercentage) / 100;
          
           uint  amountToWithdraw = balance - penaltyAmount;

            IERC20(_token).transfer(developerAddress, penaltyAmount); 
             IERC20(_token).transfer(owner, amountToWithdraw);
           

        }
        
        withdrawnByToken[_token] = true;
        balances[owner][_token] = 0;
        return true;
        }

        function getEmergencyBalance(address _token) public  view returns (uint){
    
        return IERC20(_token).balanceOf(address(this));

    }

    //     function emergencyWithdraw(address _token) public onlyOwner {
    //     uint balance = getEmergencyBalance(_token);
    //     if (balance == 0) revert InsufficientFunds();

    //     IERC20(_token).transfer(owner, balance);
    //     isWithdrawn = true;
    // }
    function emergencyWithdraw(address _token) public onlyOwner {
        uint contractBalance = IERC20(_token).balanceOf(address(this));
    if (contractBalance == 0) revert InsufficientFunds();

    IERC20(_token).transfer(owner, contractBalance);
}


  

  }
