var runId = 0
  var localApi = ObjectAPI(username: "*", secret: "*", hostname: "testrail.io", port: 443, scheme: "https")
  var localAPI = API(username: "*", secret: "*", hostname: "testrail.io", port: 443, scheme: "https")
    

func createRun() {
        
        let runN = NewRun(assignedtoId: 2, caseIds: nil, description: nil, includeAll: false, milestoneId: nil, name: "Auto in progressSSSS", suiteId: nil)
        
        localApi.addRun(runN, toProjectWithId: 13) { (outcome) in
           switch outcome {
           case .failure(let error):
               print(error.debugDescription)
           case .success(let optionalParent):
               do {
                self.runId = try outcome.get().id
               } catch {
                print("unables to catch error")
                }
            }
        }
    }

    func ttExample() {
        createRun()
        Thread.sleep(forTimeInterval: 5)
        updateRunWithTestCases()
        Thread.sleep(forTimeInterval: 5)

        endRun()
    }

    func update(caseIds: [Int], runId: Id) {
        let caseUpdate = CaseUpdate(case_ids: caseIds)
        let jsonData = try! JSONEncoder().encode(caseUpdate)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        localAPI.updateRun(runId: self.runId, data: jsonString.data(using: .utf8)!)
        {
            (outcome) in
            print("SOMEREPORT")
            print(outcome)
            print("---->SOMEREPORT")

        }

    }
    
    func updateRunWithTestCases() {
        update(caseIds: [93])
        Thread.sleep(forTimeInterval: 10)

        
        let result2 = NewResult(assignedtoId: nil, comment: "ERROR REPORTING", defects: "", elapsed: nil, statusId: 1, version: nil, customFields: nil)
        localApi.addResultForCase(result2, toRunWithId: self.runId, toCaseWithId: 93) {
         (outcome) in
            
            print(outcome)
        }
        update(caseIds: [77,93])
        Thread.sleep(forTimeInterval: 10)
        let result = NewResult(assignedtoId: nil, comment: "NOTHING TO REPORT", defects: nil, elapsed: nil, statusId: 5, version: nil, customFields: nil)
        localApi.addResultForCase(result, toRunWithId: self.runId, toCaseWithId: 77) {
         (outcome) in
            print(outcome)

        }
    }

    func endRun() {
        if self.runId > 0 {
            localApi.closeRun(self.runId) { _ in return }
        }
    }
	
	struct CaseUpdate:Codable {
	    var case_ids: [Int]
	}
	