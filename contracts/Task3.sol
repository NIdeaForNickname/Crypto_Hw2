
pragma solidity ^0.8.0;

contract EducationGrant {
    address public owner;

    struct Student {
        uint256 balance;
        bool isGraduated;
    }

    mapping(address => Student) public students;

    event Deposit(address indexed student, uint256 amount);
    event GrantPaid(address indexed student, uint256 amount);
    event StudentCertified(address indexed student);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can certify");
        _;
    }

    constructor() { owner = msg.sender; }

    function deposit(address _student) public payable {
        students[_student].balance += msg.value;
        emit Deposit(_student, msg.value);
    }

    function certifyCompletion(address _student) public onlyOwner {
        students[_student].isGraduated = true;
        emit StudentCertified(_student);
    }

    function withdrawGrant() public {
        Student storage s = students[msg.sender];
        require(s.isGraduated, "Education not completed or certified");
        require(s.balance > 0, "No funds available");

        uint256 amount = s.balance;
        s.balance = 0;
        payable(msg.sender).transfer(amount);
        emit GrantPaid(msg.sender, amount);
    }
}