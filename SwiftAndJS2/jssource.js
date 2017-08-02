var helloWorld = "Hellow World!"

function getFullname(firstname, lastname) {
    return firstname + " " + lastname;
}

function maxMinAverage(values) {
    var max = Math.max.apply(null, values);
    var min = Math.min.apply(null, values);
    var average = null;
    
    if (values.length > 0) {
        var sum = 0;
        for (var i=0; i < values.length; i++) {
            sum += values[i];
        }
        average = sum / values.length;
    }
    
    return {
        "max" : max,
        "min" : min,
        "average" : average
    };
}

function gererateLuckyNumber() {
    var luckyNumbers = [];
    
    while (luckyNumbers.length != 6) {
        var randomNumber = Math.floor((Math.random() * 50) + 1);
        
        if (!luckyNumbers.includes(randomNumber)) {
            luckyNumbers.push(randomNumber);
        }
    }
    
    consoleLog(luckyNumbers);
    handleLuckyNumbers(luckyNumbers);
}

function convertMarkdownToHTML(source) {
    var converter = new showdown.Converter();
    var htmlResult = converter.makeHtml(source);
    consoleLog(htmlResult);
    handleConvertedMarkdown(htmlResult);
}

function parseiPhoneList(originalData) {
//    参数 { header: true } 表明 csv 档案中的第一行是表头，表头在剖析时会自动变成返回结果中的 key
//    當剖析完成，results 變量中會保存有 3 個陣列data:errors:meta:
        var results = Papa.parse(originalData, { header: true });
        if (results.data) {
            var deviceData = [];
    
            for (var i=0; i<results.data.length; i++) {
                var model = results.data[i]["Model"];
    
                var deviceInfo = DeviceInfo.initializeDeviceWithModel(model);
    
                deviceInfo.initialOS = results.data[i]["Initial OS"];
                deviceInfo.latestOS = results.data[i]["Latest OS"];
                deviceInfo.imageURL = results.data[i]["Image URL"];
    
                deviceData.push(deviceInfo);
            }
            return deviceData;
        }
        return null;
}
