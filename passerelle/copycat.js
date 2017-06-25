const alexa = require('alexa-app');
const https = require('https');
const app = new alexa.app('copycat');
//const COPYCAT_DEMO_CLIENT_TOKEN = 'd9a1c1875b8b43caa7c4810afe372bba';
const COPYCAT_DEMO_CLIENT_TOKEN = '79d8e0e0bed944999b16af4b222253ed';
const apiai = require('apiai')('9448c67926d44ace85b18a470c2c0cf7' || COPYCAT_DEMO_CLIENT_TOKEN);
const md5 = require('md5');

function copycat(express) {
  app.launch((req, res) => {
    res.shouldEndSession(false);
    res.reprompt(`Are you still there? I'll help you with your shop lists`);
    res.say(`Hello welcome to Shwett Lists by Casino ! I have 22 products in your main list. Would you like to add one ?`);
  });

  app.intent('catchAllIntent', {
      slots: {
        catch: 'CatchAll',
      },
      utterances: [
        '{-|catch}',
      ]
    },
    (req, res) => {
      const catchall = req.slot('catch');
      //res.say(catchall);
      res.shouldEndSession(false);
      res.reprompt('Still awake?');
      console.log('got:', catchall);

      apiaiQuery(catchall, req.sessionDetails.sessionId, function (error, response) {
        if (error) {
          console.error('API.ai error', error);
        } else {
          console.log('API response:', response);
          var options = {
            host: 'chouetteslistes.herokuapp.com',
            port: 443,
            path: '/search/'+response.result.parameters.Produit
          };
          https.get(options);
          if(response.result.parameters.Produit == 'Coke'){
            res.say('Great, coke added ! Hey Camille, I have a favor to ask : may I come to your party ? Please ! Please !').send()
          }else if(response.result.parameters.Produit == 'Rhum'){
            res.say('Okay, I added one bottle of Rhum! Camille, may I suggest coke with this ?').send()
          }else{
            res.say(response.result.fulfillment.speech).send()
          }
          //console.log('Ill say that :', res.say())
        }
      });
    return false;
    }
  );

  app.intent('errorIntent', (req, res) => {
    res.say('There was an error!');
  });

  app.error = (e, req, res) => {
    res.say('Got exception. ' + e.message);
    console.error('error handler! ', e);
  };

  app.sessionEnded((req, res) => {
    console.log('sessionEnded because:', req.data.request.reason);
  });

  app.express(express, '/alexa/', true);
}

function apiaiQuery(query, sessionId, cb) {
  if (apiai) {
    const request = apiai.textRequest(query, {
      // Apply md5 the session id to fit within API.ai's 36 character limit
      sessionId: md5(sessionId)
    });

    request.on('response', function (response) {
      cb(null, response);
    });

    request.on('error', function (error) {
      console.log(error);
      cb(error);
    });

    request.end();
  }
}

module.exports = {
  copycat: copycat
};
