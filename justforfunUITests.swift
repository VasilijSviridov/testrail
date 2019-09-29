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
        updateRunWithTestCases()
        endRun()
    }

    func updateRunWithTestCases() {
        let caseUpdate = CaseUpdate(case_ids: [77,93])
        let jsonData = try! JSONEncoder().encode(caseUpdate)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        localAPI.updateRun(runId: self.runId, data: jsonString.data(using: .utf8)!)
        {
            (outcome) in
            
            print(outcome)
        }
                
        let result2 = NewResult(assignedtoId: nil, comment: "ERROR REPORTING", defects: "", elapsed: nil, statusId: 5, version: nil, customFields: nil)
        localApi.addResultForCase(result2, toRunWithId: self.runId, toCaseWithId: 93) {
         (outcome) in
        }
        Thread.sleep(forTimeInterval: 5)
        let result = NewResult(assignedtoId: nil, comment: "NOTHING TO REPORT", defects: nil, elapsed: nil, statusId: 1, version: nil, customFields: nil)
        localApi.addResultForCase(result, toRunWithId: self.runId, toCaseWithId: 77) {
         (outcome) in
        }
    }

    func jsonToNSData(json: Any) -> Data?{
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    
    
    
    func endRun() {
        if self.runId > 0 {
            localApi.closeRun(self.runId) { _ in return }
        }
    }