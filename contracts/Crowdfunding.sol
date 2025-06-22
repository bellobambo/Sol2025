// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract CrowdfundFactory {
    // Project structure
    struct Project {
        string title;
        uint256 goalAmount;
        uint256 totalRaised;
        uint256 startTime;
        uint256 endTime;
        address owner;
        bool exists;
    }

    // Track all projects
    uint256 public projectCount;
    mapping(uint256 => Project) public projects;
    mapping(uint256 => mapping(address => uint256)) public contributions;
    mapping(uint256 => address[]) public contributors;

    // Events
    event ProjectCreated(uint256 projectId, address owner, string title);
    event Contributed(uint256 projectId, address donor, uint256 amount);
    event FundsWithdrawn(uint256 projectId, uint256 amount);
    event RefundClaimed(uint256 projectId, address donor, uint256 amount);

    // Create a new project
    function createProject(
        string memory _title,
        uint256 _goalAmount,
        uint256 _durationInDays
    ) external {
        uint256 projectId = projectCount++;
        
        projects[projectId] = Project({
            title: _title,
            goalAmount: _goalAmount,
            totalRaised: 0,
            startTime: block.timestamp,
            endTime: block.timestamp + (_durationInDays * 1 days),
            owner: msg.sender,
            exists: true
        });

        emit ProjectCreated(projectId, msg.sender, _title);
    }

    // Contribute to a project
    function contribute(uint256 _projectId) external payable {
        Project storage project = projects[_projectId];
        require(project.exists, "Project doesn't exist");
        require(block.timestamp >= project.startTime && block.timestamp <= project.endTime, "Not in funding period");
        require(msg.value > 0, "Must send ETH");

        if (contributions[_projectId][msg.sender] == 0) {
            contributors[_projectId].push(msg.sender);
        }

        contributions[_projectId][msg.sender] += msg.value;
        project.totalRaised += msg.value;

        emit Contributed(_projectId, msg.sender, msg.value);
    }

    // Withdraw funds (project owner)
    function withdrawFunds(uint256 _projectId) external {
        Project storage project = projects[_projectId];
        require(msg.sender == project.owner, "Only owner");
        require(block.timestamp > project.endTime, "Funding not ended");
        require(project.totalRaised >= project.goalAmount, "Goal not reached");

        uint256 amount = project.totalRaised;
        project.totalRaised = 0;

        (bool success, ) = project.owner.call{value: amount}("");
        require(success, "Transfer failed");

        emit FundsWithdrawn(_projectId, amount);
    }

    // Get refund (contributors)
    function claimRefund(uint256 _projectId) external {
        Project storage project = projects[_projectId];
        require(block.timestamp > project.endTime, "Funding not ended");
        require(project.totalRaised < project.goalAmount, "Goal was reached");
        require(contributions[_projectId][msg.sender] > 0, "No contribution");

        uint256 amount = contributions[_projectId][msg.sender];
        contributions[_projectId][msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        emit RefundClaimed(_projectId, msg.sender, amount);
    }

    // Helper functions
    function getProjectDetails(uint256 _projectId) public view returns (
        string memory title,
        uint256 goalAmount,
        uint256 totalRaised,
        uint256 startTime,
        uint256 endTime,
        address owner
    ) {
        Project memory project = projects[_projectId];
        return (
            project.title,
            project.goalAmount,
            project.totalRaised,
            project.startTime,
            project.endTime,
            project.owner
        );
    }

    function getContributorCount(uint256 _projectId) public view returns (uint256) {
        return contributors[_projectId].length;
    }
}