const { expect } = require("chai")

describe("memory storage comparison", function () {

  let MemoryOrStorage;
  let addr1
  let addr2
  let addr3
  let addr4

  beforeEach(async function () {
    [addr1, addr2, addr3, addr4] = await ethers.getSigners()
    const MemoryOrStorageFactory = await ethers.getContractFactory("MemoryOrStorage")
    MemoryOrStorage = await MemoryOrStorageFactory.deploy(addr1.address,
                                                          addr2.address,
                                                          addr3.address,
                                                          addr4.address)
    await MemoryOrStorage.deployed()
  })

  it("perform a longer series of ops", async function () {
    for (let j = 0; j < 10; j++) {
      let stateMemory = await MemoryOrStorage.stateMemory(j)
      let stateStorage = await MemoryOrStorage.stateStorage(j)
      console.log("memory", stateMemory.executed, "storage", stateStorage.executed)
    }
  }) 

})
