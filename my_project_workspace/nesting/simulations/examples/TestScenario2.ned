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
import nesting.node.ethernet.VlanEtherHostSched;
import nesting.node.ethernet.VlanEtherSwitchPreemptable;


network TestScenario2
{
    parameters:

	@figure[sentPkText](type=indicatorText; pos=220,13; anchor=w; font=,10; textFormat="sent from wkstn1: %g"; initialValue=0);
        @statistic[packetSent](source=workstation1.trafGenApp[0].packetSent; record=figure(count); targetFigure=sentPkText);

	@figure[sentPkText3](type=indicatorText; pos=220,24; anchor=w; font=,10; textFormat="sent from cntrlr: %g"; initialValue=0);
	// note how it's a different variable being called because it doesn't inherit from inet module but has its own
        @statistic[packetSent3](source=robotController.trafGenSchedApp[0].sentPk; record=figure(count); targetFigure=sentPkText3);

	@figure[rcvdPkText](type=indicatorText; pos=400,13; anchor=w; font=,10; textFormat="packets received at backupServer: %g"; initialValue=0);
        @statistic[packetReceived](source=backupServer.trafGenApp[0].packetReceived; record=figure(count); targetFigure=rcvdPkText);

	@figure[rcvdPkText2](type=indicatorText; pos=400,24; anchor=w; font=,10; textFormat="packets received at roboticArm: %g"; initialValue=0);
        @statistic[packetReceived2](source=roboticArm.trafGenApp[0].packetReceived; record=figure(count); targetFigure=rcvdPkText2);

	@figure[rcvdPkText3](type=indicatorText; pos=400,35; anchor=w; font=,10; textFormat="packets received at switchB: %g"; initialValue=0);
        @statistic[packetReceived3](source=switchB.eth[2].packetReceivedFromLower; record=figure(count); targetFigure=rcvdPkText3);
	
    types:
        channel C extends DatarateChannel
        {
            delay = 0.1us;
            datarate = 1Gbps;
        }
    submodules:
        switchA: VlanEtherSwitchPreemptable {
            parameters:
                @display("p=188,127");
            gates:
                ethg[4];
        }
        switchB: VlanEtherSwitchPreemptable {
            parameters:
                @display("p=327,127");
            gates:
                ethg[3];
        }
        workstation1: VlanEtherHostQ {
            @display("p=79,62");
        }
        //workstation2: VlanEtherHostQ {
            //@display("p=172,29");
        //}
        backupServer: VlanEtherHostQ {
            @display("p=446,54");
        }
        robotController: VlanEtherHostSched {
            @display("p=79,202");
        }
        roboticArm: VlanEtherHostQ {
            @display("p=440,202");
        }
    connections allowunconnected:
        robotController.ethg <--> C <--> switchA.ethg[0];
        workstation1.ethg <--> C <--> switchA.ethg[1];
        //workstation2.ethg <--> C <--> switchA.ethg[2];

        roboticArm.ethg <--> C <--> switchB.ethg[0];
        backupServer.ethg <--> C <--> switchB.ethg[1];

        switchA.ethg[3] <--> C <--> switchB.ethg[2];
}
