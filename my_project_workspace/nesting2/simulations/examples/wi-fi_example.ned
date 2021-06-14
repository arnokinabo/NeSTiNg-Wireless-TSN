//
// This program is property of its copyright holder. All rights reserved.
//

package nesting.simulations.examples;

import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.inet.Router;
import inet.node.inet.WirelessHost;
import inet.node.wireless.AccessPoint;
import inet.physicallayer.contract.packetlevel.IRadioMedium;
import inet.visualizer.contract.IIntegratedVisualizer;
import ned.DatarateChannel;

network wifi_example
{
    parameters:
        @display("bgb=650,500;bgg=100,1,grey95");
        @figure[title](type=label; pos=0,-1; anchor=sw; color=darkblue);

	bool useEthernetSwitching = default(true);
        bool useRouting = default(false);
    submodules:
        visualizer: <default(firstAvailableOrEmpty("IntegratedCanvasVisualizer"))> like IIntegratedVisualizer if typename != "" {
            parameters:
                @display("p=100,300;is=s");
        }
        radioMedium: <default("Ieee80211ScalarRadioMedium")> like IRadioMedium {
            parameters:
                @display("p=100,200;is=s");
        }
        configurator: Ipv4NetworkConfigurator {
            parameters:
                @display("p=100,100;is=s");
        }
        host1: WirelessHost {
            parameters:
                @display("p=85,203");
        }
        host2: WirelessHost {
            parameters:
                @display("p=454,203");
        }
        accessPoint1: AccessPoint {
            parameters:
                @display("p=150,99");
        }
        accessPoint2: AccessPoint {
            parameters:
                @display("p=354,99");
        }
        router: Router if useRouting {
            parameters:
                @display("p=255,168");
        }
    connections:
        accessPoint1.ethg++ <--> DatarateChannel {  datarate = 100Mbps; } <--> accessPoint2.ethg++ if useEthernetSwitching;
}
