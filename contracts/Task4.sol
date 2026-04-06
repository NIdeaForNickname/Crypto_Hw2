pragma solidity ^0.8.0;

contract EmergencyFund {
    mapping(address => uint256) public contributions;
    address[] public members;
    
    struct Request {
        address payable recipient;
        uint256 amount;
        uint256 approvals;
        bool executed;
    }

    Request[] public requests;
    mapping(uint256 => mapping(address => bool)) public votes;

    constructor(address[] memory _members) {
        members = _members;
    }

    function contribute() public payable {
        contributions[msg.sender] += msg.value;
    }

    function createEmergencyRequest(uint256 _amount) public {
        requests.push(Request(payable(msg.sender), _amount, 0, false));
    }

    function approveRequest(uint256 _reqId) public {
        bool isMember = false;
        for(uint i=0; i<members.length; i++) if(members[i] == msg.sender) isMember = true;
        
        require(isMember, "not a member");
        require(!votes[_reqId][msg.sender], "already voted");

        votes[_reqId][msg.sender] = true;
        requests[_reqId].approvals++;
    }

    function executeRequest(uint256 _reqId) public {
        Request storage req = requests[_reqId];
        require(req.approvals > members.length / 2, "not enough approvals");
        require(!req.executed, "already executed");
        require(address(this).balance >= req.amount, "no money");

        req.executed = true;
        req.recipient.transfer(req.amount);
    }
}