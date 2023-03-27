const { expect } = require("chai");

describe("Car Contract", function () {
  it("It Should assign the given owner to the car", async function () {
    // It is to get the deployer of smart contract
    const [owner] = await ethers.getSigners();

    // To get the the car contract - It's from an ABI created by compiling the code
    // Always make sure to compile your code ahead of testing
    const Car = await ethers.getContractFactory("Car");

    // Deploying the ABI on the network connected
    const carContract = await Car.deploy();

    await carContract.addCar("Civic", "VLI", 2022, owner.address, 1);

    const car = await carContract.getCar(1);
    expect(car.owner).to.equal(owner.address);
  });

  it("TransferCar should only successfully executes the transfer function if the owner is calling it", async function () {
    const transferAddress = "0xbe4351723ba43AA17a7972897634d74Cd89CAA05";

    // It is to get the deployer of smart contract
    const [owner] = await ethers.getSigners();

    // To get the the car contract - It's from an ABI created by compiling the code
    // Always make sure to compile your code ahead of testing
    const Car = await ethers.getContractFactory("Car");

    // Deploying the ABI on the network connected
    const carContract = await Car.deploy();

    await carContract.addCar("Civic", "VLI", 2022, owner.address, 1);

    await carContract.transferCar(transferAddress, 1);

    const car = await carContract.getCar(1);
    expect(car.owner).to.equal(transferAddress);
  });

  it("GetCar should return the correct car results given the id", async function () {
    // It is to get the deployer of smart contract
    const [owner] = await ethers.getSigners();

    // To get the the car contract - It's from an ABI created by compiling the code
    // Always make sure to compile your code ahead of testing
    const Car = await ethers.getContractFactory("Car");

    // Deploying the ABI on the network connected
    const carContract = await Car.deploy();

    await carContract.addCar("Civic", "VLI", 2022, owner.address, 1);

    const car = await carContract.getCar(1);

    expect(car.owner).to.equal(owner.address);
    expect(car.name).to.equal("Civic");
    expect(car.model).to.equal("VLI");
    expect(car.year).to.equal(2022);
  });
});
