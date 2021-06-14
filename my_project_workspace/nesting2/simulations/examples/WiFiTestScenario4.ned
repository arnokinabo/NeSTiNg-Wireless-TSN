//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package nesting.simulations.examples;

import ned.DatarateChannel;
import nesting.node.ethernet.VlanEtherHostQ;
import nesting.node.ethernet.VlanEtherHostQWireless;
import nesting.node.ethernet.VlanEtherHostSched;
//import nesting.node.ethernet.VlanEtherSwitchPreemptable;
import inet.node.ethernet.EtherSwitch;
// my extra wireless packages:
import inet.visualizer.contract.IIntegratedVisualizer;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.wireless.AccessPoint;
import inet.physicallayer.contract.packetlevel.IRadioMedium;

network WiFiTestScenario4
{
	// my parameters:
    parameters:
        @display("bgb=650,500;bgg=100,1,grey95");
        @figure[title](type=label; pos=0,-1; anchor=sw; color=darkblue);
        
        @figure[sentPkText](type=indicatorText; pos=220,13; anchor=w; font=,10; textFormat="sent from wkSta1: %g"; initialValue=0);
        @statistic[packetSent](source=workstation1.trafGenApp[0].packetSent; record=figure(count); targetFigure=sentPkText);

	@figure[sentPkText3](type=indicatorText; pos=220,24; anchor=w; font=,10; textFormat="sent from cntlr: %g"; initialValue=0);
	// note how it's a different variable being called because it doesn't inherit from inet module but has its own
        @statistic[packetSent3](source=robotController.trafGenSchedApp[0].sentPk; record=figure(count); targetFigure=sentPkText3);

	@figure[rcvdPkText](type=indicatorText; pos=400,13; anchor=w; font=,10; textFormat="packets received at backupServer: %g"; initialValue=0);
        @statistic[packetReceived](source=backupServer.trafGenApp[0].packetReceived; record=figure(count); targetFigure=rcvdPkText);

	@figure[rcvdPkText2](type=indicatorText; pos=400,24; anchor=w; font=,10; textFormat="packets received at roboticArm: %g"; initialValue=0);
        @statistic[packetReceived2](source=roboticArm.trafGenApp[0].packetReceived; record=figure(count); targetFigure=rcvdPkText2);

	@figure[rcvdPkText3](type=indicatorText; pos=400,35; anchor=w; font=,10; textFormat="packets received at switchB: %g"; initialValue=0);
        @statistic[packetReceived3](source=switchB.eth[2].packetReceivedFromLower; record=figure(count); targetFigure=rcvdPkText3);
        
    types:
        channel C1 extends DatarateChannel
        {
            delay = 0.1us;
            datarate = 1Gbps;
        }
	channel C2 extends DatarateChannel
        {
            delay = 0.1us;
            datarate = 100Mbps;
        }
    submodules:
    	visualizer: <default(firstAvailableOrEmpty("IntegratedCanvasVisualizer"))> like IIntegratedVisualizer if typename != "" {
            parameters:
                @display("p=100,300;is=s");
        }
    	configurator: Ipv4NetworkConfigurator {
            parameters:
                @display("p=80,300;is=s");
        }
        switchA: EtherSwitch {
            parameters:
                @display("p=188,127");
            gates:
                ethg[4];
        }
        switchB: EtherSwitch {
            parameters:
                @display("p=327,127");
            gates:
                ethg[3];
        }
        accessPoint2: AccessPoint {
            parameters:
                @display("p=400,127");
        }
        radioMedium: <default("Ieee80211ScalarRadioMedium")> like IRadioMedium {
            @display("p=446,100");
        }
        workstation1: VlanEtherHostQ {
            @display("p=79,62");
        }
        backupServer: VlanEtherHostQWireless {
            @display("p=446,54");
        }
        robotController: VlanEtherHostSched {
            @display("p=79,202");
        }
        roboticArm: VlanEtherHostQWireless {
            @display("p=440,202");
        }
        
    //connections:
    connections allowunconnected:
        robotController.ethg <--> C1 <--> switchA.ethg[0];
        workstation1.ethg <--> C2 <--> switchA.ethg[1];
        //workstation2.ethg <--> C <--> switchA.ethg[2];

        //roboticArm.ethg <--> C <--> switchB.ethg[0];
        //backupServer.ethg <--> C <--> switchB.ethg[1];

        switchA.ethg[3] <--> C1 <--> switchB.ethg[2];
        accessPoint2.ethg++ <--> C1 <--> switchB.ethg[1];
}
