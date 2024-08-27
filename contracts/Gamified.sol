// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GamifiedGroupProject {
    struct Task {
        string description;
        address assignedTo;
        uint256 reward;
        bool isCompleted;
    }

    address public owner;
    mapping(uint256 => Task) public tasks;
    uint256 public taskCount;
    mapping(address => uint256) public rewards;

    event TaskCreated(uint256 taskId, string description, uint256 reward);
    event TaskCompleted(uint256 taskId, address completedBy);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyAssigned(uint256 taskId) {
        require(tasks[taskId].assignedTo == msg.sender, "You are not assigned to this task");
        _;
    }

    function createTask(string memory _description, address _assignedTo, uint256 _reward) public onlyOwner {
        taskCount++;
        tasks[taskCount] = Task(_description, _assignedTo, _reward, false);
        emit TaskCreated(taskCount, _description, _reward);
    }

    function completeTask(uint256 taskId) public onlyAssigned(taskId) {
        require(!tasks[taskId].isCompleted, "Task already completed");

        tasks[taskId].isCompleted = true;
        rewards[msg.sender] += tasks[taskId].reward;

        emit TaskCompleted(taskId, msg.sender);
    }

    function withdrawRewards() public {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards available");

        rewards[msg.sender] = 0;
        payable(msg.sender).transfer(reward);
    }

    function deposit() public payable onlyOwner {}

    // Additional functions to manage group interactions can be added here
}

