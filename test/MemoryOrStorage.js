const { expect } = require("chai")

describe("memory storage comparison", function () {

  let MemoryOrStorage;
  // let addr1
  // let addr2
  // let addr3
  // let addr4

  beforeEach(async function () {
    [addr1, addr2, addr3, addr4] = await ethers.getSigners()
    const MemoryOrStorageFactory = await ethers.getContractFactory("MemoryOrStorage")
    MemoryOrStorage = await MemoryOrStorageFactory.deploy()
    // MemoryOrStorage = await MemoryOrStorageFactory.deploy(addr1.address,
    //                                                       addr2.address,
    //                                                       addr3.address,
    //                                                       addr4.address)
    await MemoryOrStorage.deployed()
  })

  it("read the state values", async function () {
    for (let j = 0; j < 10; j++) {
      await MemoryOrStorage.stateMemory(j)
      await MemoryOrStorage.stateStorage(j)
    }
  }) 

})
