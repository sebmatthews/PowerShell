Greetings Happy Powersheller!

Thanks for downloading this set of scripts.  

I hope you get some value out of the experience they will provide.


The Disclaimer Bit

Let's get one thing straight.  These scripts are not designed to be used as production quality installation/deployment/configuration scripts for SharePoint 2010.  They are intended to be educational.

These scripts are provided as-is, no warranty of any kind (expressed or implied) is provided, and you use these scripts at your own risk.  

They have been tested in several environments (both physical and virtual) and work in the way they are intended to work.  Chances are, if things are not working for you it's a problem with how you are using the scripts, an issue in your underlying platform (Windows, AD, SQL Server, etc.) or with how you have used the (XML/CSV/etc.) configuration file if there is one present.

Please don't call me, email me, flame me or otherwise make negative commentary in a public forum if these scripts don't work for you or if you have something to say that might be perceived in a negative way.  Be an adult and reach out (see below) and if we can make things better then we can do so, and I'll make sure your contribution is recognised.  I'm known to fight fire with fire so if you do want to open up a can of hater whoop-ass in a public forum expect me to bring the rain Carrier Battle Group style. Yep. Proper rain-bringing - harsh words, tongue poking, finger wagging, mini-guns, Tomahawks, submarines, JSTARS assisted orbital defence platforms and sharp sticks :)

I know you know this, but I will say it anyway.  There are many ways to skin the SharePoint and PowerShell cat.  

Furstly (geddit?), I'm not advocating skinning cats.  

Seriously though, I'm not suggesting in any way that the approaches used within these scripts are the best way to do things.  In fact in some places the scripts are verbose, bloaty and could do with optimisation.  I know this, and anybody worth their salt will also know this.  

The aim was to include as many principles of PowerShell as possible and to do this requires some slightly peculiar constructs and approaches from time to time.  Bear this in mind.

Lastly. When you use these scripts, take the precautions you know you should.  Think of it as Scripting Prophylaxis.  Liberally sprinkle sysprep, snapshots, backups and other rollback techniques into your scripting broth.  Make sure you are happy to lose the environment in which you are scripting, there is nothing quite as upsetting as blowing something up when you really, actually, positively needed it.

Safe Scripting prevents STIs! (Scripting Total Implosions) <insert poster here>


The Acknowledgements Bit

Scripting in PowerShell is a collaborative effort.  

What do I mean by this?  Simple. Ever since the concept of "Visual" development emerged a while back, copy/paste development and scripting has become the norm.  With the ever increasing prevalence of internet technologies such as the world wide web and social networks (twitter in particular) finding answers to problems is becoming easier and eaiser, in fact chances are you found this set of scripts via twitter, a blog or some kind of web search - am I right?

What's my point?  Elements of these scripts have probably been gathered from a number of sources.  Snippets here, blocks there and the odd technique have been fertilised, inspired, or borrowed from numerous sources.

I've not been diligent in my recording of what came from where but suffice it to say that a number of folks have helped in the development of this stuff - whether they know it or not.

For a fact, I know that inspiration in some form has come from many sources and I acknowledge the part others played in the creation of this set of scripts.

I will call out one person in particular - Ed Wilson at Microsoft (@scriptingguys) is a standout member of the PowerShell community and it seems I learn something from him (and his guest bloggers) almost everyday.  If you want to know more about the principles of PowerShell, Ed is your man without question.  Follow him to the point of stalking :)


The From the Heart Bit

I've tried to make the scripts as easy to follow as possible with (what I believe to be) an appropriate level of commenting included.

The principal purpose of these scripts is to show you fundamental PowerShell concepts and constructs.  I find that when I am stretching my legs with a new technology, real-world context helps me so wrapping the PowerShell concepts in a real-world example creating stuff inside SharePoint seemed like a good idea.  Although purposed to SharePoint, this set of scripts is not uniquely aimed at SharePoint people (although it originally was) it's just trying to create something real and educational as opposed to being abstract.

Note to PowerShell people:  

Understand the context of these scripts.  They have been broken out into a suite of numbered individual scripts as opposed to being functions contained (for instance) within a module or dot sourceable super-script.  

Why?  Two reasons. 

Firstly, for those new to PowerShell, jumping over all the basics straight to understanding functions is a leap and a half and goes against the ethos of this script suite.  Secondly, the first version of this set of scripts was shown as part of a conference session series that referenced the numbered individual scripts and a number of people still use these scripts in that context.  In a later revision, I fully intend (*ahem*) to provide a version of this script set deployable as a module, largely to show how script modules work :)


The Final Bit

If you do want to reach out to me, please find me on twitter (@sebmatthews).  

Reach out nicely, politely and with patience and I'll gladly open up a dialogue, I am a nice bloke at heart and like most normal, well balanced humans respond to niceness and bribery.

Some personal thanks goes to: Jason Himmelstein, Brian Lalancette, Dan Usher and Scott Hoag. 
Why?  Jason as he is my partner in PowerShell, Brian for bringing something Enterprise class to the SharePoint/PowerShell world, and Dan and Scott (a.k.a. Bert & Ernie) for Try...Catch...Finally.  They know what I mean.

The contents of the ZIP and all of the scripts are covered under the GNU GPL v3 Public Licence.  Respect it coz Karma is a biatch.

Thanks for taking the time.
Seb Matthews
November 2014
