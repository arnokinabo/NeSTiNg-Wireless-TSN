# Appendix A

The procedure for installing OMNeT, virtualization and other tools for the experiment relevant to Section 4 is detailed here. This section also documents a list of the errors encountered during the installation and development phases, and how they were resolved.

## Install procedure:
1)	On the Windows machine, the Oracle VM VirtualBox Manager was downloaded and installed.
2)	An ISO image of the latest LTS (Long-Term Support) Ubuntu OS version at the time (Ubuntu 18.04 – Bionic Beaver) was obtained from the Ubuntu official site
3)	A virtual machine was created using the ISO. Detailed steps can be found on the VirtualBox site
4)	Additional settings were configured once the VM was up and running. These are known as VirtualBox Guest Additions.
They are a collection of device drivers and system applications that aid the user to have a better experience while working in a virtualised environment. Although similar settings come with the Ubuntu (or other OS) ISO image, usually the repository is outdated and so they do not fit so well with the current VM settings. These VirtualBox Guest Additions ship with the Oracle VirtualBox software, and their install procedure is detailed quite clearly here [70]. 
The guest additions help with a number of things:
-	Easy mouse pointer integration
-	Shared clipboard for copying and pasting things both ways between the guest and host systems
-	Drag and drop feature which also works bidirectionally between the guest and host
-	Seamless Windows feature, which was the most important for this work. It enabled the windows open in the guest machine to automatically adjust to fit the Windows of the host, for a better viewing experience
-	Other features include accelerated video performance and better time synchronisation to name a few.
5)	Next came the task to install the foundation for the simulation environment. 
As highlighted in Fig 7, OMNeT++ was first on the list. The prescribed OMNeT version was chosen going off the instructions of the Distributed Systems group of IPVS. Detailed instructions on its installation can be found in its (OMNeT) documentation [54]. Although sometimes these steps do not go according to plan majorly because of unmatched program dependencies, a fact usually stemming from outdated programs in the Ubuntu repository which leads to missing prerequisite programs. Secondary assistance came through a source found here [71]
6)	The INET version chosen by the Distributed Systems group was used to run its installation.
Even though OMNeT provides a prompt for downloading the INET library upon its first-time use, sometimes it has to be installed manually, which was the case in this project. Instructions from the INET installation page on its home site help with this [57].
7)	Even after successful installation there may be further errors encountered when launching the OMNeT IDE, prompting the user to check the logs files. It was revealed in [72] that “OMNeT++ 5.4.1 is based on Eclipse 4.7.3 and The java 11 broke the compatibility with Eclipse 4.7 which in turn causes the issue with OMNeT++ 5.4.1.” The author tried his second workaround for the problem and solution described, and found it cleared the error immediately.
8)	The rest of the procedure for installing NeSTiNg itself is as documented in [56].
The install procedure was replicated to match the steps highlighted therein.

In the development phase, the main files used were as follows:

-	`VlanEtherHostQ.ned`, whose file path is: `my_project_workspace/nesting2/src/nesting/node/ethernet/VlanEtherHostQ.ned`
-	`01_example_strict_priority.ini`, `TestScenario.ned`, all in the same directory, whose file path is: `my_project_workspace/nesting2/simulations/examples/`
-	`TestScenarioRouting.xml`, whose file path is: `my_project_workspace/nesting2/simulations/examples/xml/TestScenarioRouting.xml`

Other files were created and used for testing purposes:
-	`Tester.ned`, `tester.ini`, `reproducible_example.ned`, `minimal_reproducible_example.ini`, all in the same directory as the above: `my_project_workspace/nesting2/simulations/examples/`

Other main files reviewed which were required for understanding are:
-	`02_example_gating.ini`, `03_example_frame_preemption.ini`, on the path: `my_project_workspace/nesting2/simulations/examples/`
The system further produced results folders to hold the result files generated from the various tests and simulations. These folders are easily differentiated because they are named after the specific simulation they describe. They lie on the path: `my_project_workspace/nesting2/simulations/examples/<results_folder>`

### Errors in Development
Upon building and running the programs developed in the simulator, there were more errors encountered:
1)	No such file or directory
When running one of the example simulations, this error kept popping up. The writer noted that it was picking only the first word of the project workspace folder’s name. It stopped at the first delimiter (space). It was resolved by changing the folder name from “my project workspace” to “my_project_workspace”. The simulations could run after this.
It is a common enough error that it pops up in other spheres of Ubuntu as well – having such spaces being replaced instead by an underscore takes care of it.
2)	Other coding errors are due to improper specification of the modules, parameters, submodules and importing of the used packages themselves. Some are obvious and are picked up by the simulator console. Others are a bit tricky to solve because the INET tutorial examples and framework guides may use a different notation than that in online forums such as StackOverflow. It may be that the INET page is based on an outdated version of INET, but whatever the case, the editors leave too much to assumption and so the writer has stocked some meaningful pages which helped with many of the issues he was facing:

a.	https://stackoverflow.com/questions/54597785/building-node-with-inet-getcontainingnicmodule-nic-module-not-found
- Contains help on configuring gates, interfaces and their connections for wireless nodes. Also, on mobility, which for wireless hosts usually has to be declared. Although it should be noted this node extends another and is not a fully custom one, so some commands may differ depending on your goal – which was the case for this work. Still, it provides valuable insight into what has changed from the old INET, and what needs to be configured.

b.	https://stackoverflow.com/questions/36615266/how-can-i-combine-my-customize-module-with-omnetinets-simple-module
- May be a bit outdated, but it provides a thorough guide on how to build and customize your own module, which is essentially what NeSTiNg does with its VlanEtherHostQ.ned file for example. Provides a good reference on what needs to be included. Pay attention as some of the syntax is for older INET and OMNeT++ versions.

c.	https://stackoverflow.com/questions/50617868/connecting-wireless-hosts-to-a-standard-host-via-ap-in-omnet
- Good base to start as well because the scenario is of one which sees a wireless host connected to an access point which in turn is connected to a server: it mixes wireless and wired links, which is what the writer worked on in his simulation environment. Fairly recent. Helps with what needs to be declared in the .ini file and also adds onto knowledge on the .ned file configuration.

d.	I had to change the initial interface configuration from “WirelessInterface” to “Ieee80211Interface” in the `VlanEtherHostQ.ned` file. 
Reason – I have come to realise that certain configurations come pre-configured with parameters that would otherwise need to be defined in other layouts/configurations.
For example: another error concerning ‘.mib’ needing to be specified. This was brought on by entering the following for the mac specification with “WirelessInterface” chosen: `mac.typename = "Ieee80211Mac"`. But then you have to specify parameters like 'mib', which the system informs you as an error; to avoid this, I resolved to change the mac type to "CsmaCaMac" instead. What this did is bring a complete system, with the simulation finally beginning to run past the initial errors. 

But as soon as it starts transmitting packets from the Controller, once they reach the first switch, the next error comes up: `Upper command 'LLC_OPEN' is not handled`.
On reading about this logical link control and searching through the INET framework for possible matches about the error, I concluded it has to do with either encapsulation, or with destination mac address not being specified. At this point I found it easier to change the interface from “WirelessInterface” to “Ieee80211Interface”. With this interface you can run the system with mac type as “Ieee80211Mac” without any ‘mib’ error. And the simulation runs past the LLC_Open error. Until it reaches something else at least.

e.	The exact message is: `STA is not associated with an access point`, in the console IDE as the simulation is running. It is not an error per se, rather it is something to note of the host in question.
Reason: In the case of this work, it was missing the definition of the host’s management access point address, which is the same as the associated access point’s mac address (defined without the need for keyword “mac”). This may be defined for the STA as `wlan[*].mgmt.accessPointAddress`. But if the wireless interface definition is incomplete then it will be of no use. So, the full definition of wlan must be defined, as in the next point.

f.	For a complete definition of the wireless interface of a custom host or node, say Ieee80211Interface, one needs to indicate first in the gates input, the number of radios. This same number must be defined in the wireless interface section, as pointed out in: https://stackoverflow.com/questions/36615266/how-can-i-combine-my-customize-module-with-omnetinets-simple-module

Example:
`wlan[1]: <default("Ieee80211Interface")> like IWirelessInterface {,,,,,,,}`, means one wireless interface of the type "Ieee80211Interface".
Again, this has to be stated in the connections section, but this time the number represents the index or number of the interface in use. For the case above, one interface means starting at zero: wlan[0].

g.	Runtime error: `Implicit chunk serialization is disabled to prevent unpredictable performance degradation (you may consider changing the Chunk::enableImplicitChunkSerialization flag or passing the PF_ALLOW_SERIALIZATION flag to peek) -- in module (inet::visualizer::MediumCanvasVisualizer)`
– This issue was opened in NeSTiNg’s Github in March 2019 (issue #8), and closed sometime thereafter (See: https://gitlab.com/ipvs/nesting/-/issues/8). It seems there was an issue with the code; it has been updated to resolve it. Still, I couldn’t figure out why my INET installation picked up this error even though it was much more recent. I used Git commands to pull/merge the proper stable branch with my local folder.
