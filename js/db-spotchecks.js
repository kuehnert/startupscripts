// source: https://gist.github.com/niccottrell/3ff2efc2146090aa8c5b73c1eb75ba2c.js
// Compare two MongoDB databases, comparing count and size for all collections along with spot-checking a sample of documents
/*
MIT License
Copyright (c) 2017 Martin Buberl
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

// 1. Configure settings below
// 2. Run with "mongo db-spotchecks.js"

uriOld = "mongodb://deploy:***@127.0.0.1:27017/sokrates"
uriNew = "mongodb://deploy:***@127.0.0.1:27017/sok2"
dbNameOld = "sokrates";
dbNameNew = "sok2";

excludeCollections= ["CronLog", "HitLog", "Freq", "SystemLog", "Message"] // Exclude any non-critical collections
sample = {
  min: 10,
  max: 2000
};

// connect to mongos
connOld = new Mongo(uriOld);
dbOld = connOld.getDB(dbNameOld);

connNew = new Mongo(uriNew);
dbNew = connNew.getDB(dbNameNew);

var collPattern = new RegExp("^(" + excludeCollections.join("|") + "fs|system)\.");
print("regexp=" + collPattern.toString());

// For each collection, pick 10 docs at random and compare
dbOld.getCollectionNames().forEach(function(collname) {
  if (!collPattern.exec(collname)) {

    // Check count and size first
    cstatsOld = dbOld.runCommand( { collStats : collname  } )
    cstatsNew = dbNew.runCommand( { collStats : collname  } )
    // printjson(cstatsOld);
    // printjson(cstatsNew);
    if (cstatsOld.count === cstatsNew.count) {
       print("Count " + cstatsOld.count + " OK");
    } else {
       print("ERR Count mismatch " + cstatsOld.count  + " -> " + cstatsNew.count) ;
    }
    if (cstatsOld.size === cstatsNew.size) {
       print("Size " + cstatsOld.size + " OK");
    } else {
      print("ERR Size mismatch " + cstatsOld.size  + " -> " + cstatsNew.size) ;
    }

    fails = 0;
    // sample between 10 and 2000 docs
    count = dbOld[collname].count();
    sampleSize = Math.floor(Math.min(sample.max, Math.max(count * 0.001, sample.min)));
      print(collname + " count="+ count +" with sampleSize="+sampleSize);
    dbOld[collname].aggregate(
      [{
        $sample: {
          size: sampleSize
        }
      }]
    ).forEach(function(docOld) {
      docNew = dbNew[collname].findOne({
        _id: docOld._id
      });
      stringOld = JSON.stringify(docOld);
      stringNew = JSON.stringify(docNew);
      if (stringOld == stringNew) {
        // print("Doc matches: " + docOld._id);
      } else {
        print("Doc mismatch: " + docOld._id);
        print("Old=");
        printjson(docOld);
        print("New=");
        printjson(docNew);
        fails++;
      }
    });
    if (fails > 0) {
      print(fails + " fails");
    } else {
      print("All OK");
    }
  }
});
