const cds = require('@sap/cds')

module.exports = class myservice extends cds.ApplicationService { init() {

  this.on ('story', async (req) => {
    console.log('On story', req.data)
    let storyType = req.data.spiderman;
    console.log(storyType);
    switch (storyType) {
        case "crow":
            return "once upon a time there was a thirsty crow, it was looking for water in summer...";
            break;
        case "king":
            return "there was kind king in awadh at the time of ancient India....";
            break;
        default:
            return "please send parameter as ?name=`type e.g. king,crow`";
            break;
    }
  })

  return super.init()
}}
