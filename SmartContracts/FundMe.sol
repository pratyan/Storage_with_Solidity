pragma solidity >=0.6.6 <0.9.0;

//to import the "interfaces" from the chainlink repo
//import "@chainlink/contracts/src/v0.6/interface/AggregatorV3Interface.sol";
// "OR" just simply copy paste the whole 'Interface' contract

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}

//importing 'safeMath' contract/library
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {

    // for 'overflow' problem gonna use 'safeMath'
    using SafeMathChainlink for uint256;

    //maping for 'USER' to their money 'VALUE' sended
    mapping(address => uint256) public addressToAmountFunded;

    //variable of type 'address' to store the add of the owner of the contract
    address owner;

    //'constructor' is the first function to run auto, when the contract gets deployed
    constructor() public {
        // sets the owner = address of the contract deployer
        owner = msg.sender;
    }

    //'payable' stands for the function can take eth/wei
    function fund() public payable {
        //minimum value
        uint256 minimumUSD = 50 * 10**18;

        //check if the sender's funded value is greater than the min values
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH"); // the "msg" gonna pop out if the condition isnt filled

        //keep records of the money Funded, respective of the sender
        addressToAmountFunded[msg.sender] += msg.value;

    }

    //for getting the version of the 'AggregatorV3Interface' we have imported
    function getVersion() public view returns (uint256){
        //'Interfaces' are similar to 'struct'
        //now we will pass the address of the proxy for 'Eth/USDT' for 'Rinkby TestNet'
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x9E7D972391e460B1856576D91644d1c3Bd46a0bE);

        //now returning the version by the 'version' method in the 'AggregatorV3Interface' Interface
        return priceFeed.version();
    }

    //for getting the current price of the pair ETH/USDT with the methods in the INTERFACE
    function getPrice() public view returns (uint256) {
        //now getting the Interface
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x9E7D972391e460B1856576D91644d1c3Bd46a0bE);

        //now getting this list of data by calling the method "latestRoundData()" from the Interface

        /*
        (uint80 roundId,
         int256 answer,
         uint256 startedAt,
         uint256 updatedAt,
         uint80 answeredInRound) 
         = priceFeed.latestRoundData();
         */
         //Better insted of the above code for not getting "unused local variable", we can USE
         (,int256 answer,,,) = priceFeed.latestRoundData();

        // now since 'answer' is 'int256' ,But we are returning of type 'uint256'
        // we need to typecast it
        return uint256(answer * 10000000000); // will give us the eth price in USDT

    }

    //converting eth to USDT
    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    // for withdrawing the money send to the contract
    function withdraw() payable public {
        msg.sender.transfer(address(this).balance);// 'msg.sender' => the address of the user calling this func to withdraw all the money
                                                   // 'this' => the address of the contract we are currently in

    }
}
