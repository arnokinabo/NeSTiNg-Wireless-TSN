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

package nesting.node.ethernet;

import inet.linklayer.ethernet.EtherMacFullDuplex;
import inet.linklayer.contract.IEthernetInterface;
import nesting.application.ethernet.VlanEtherTrafGen;
import nesting.ieee8021q.clock.IClock;
import inet.networklayer.common.InterfaceTable;
// my extra wireless packages:
import inet.linklayer.contract.IWirelessInterface;
import inet.mobility.contract.IMobility;

//
// Simple Host with the capability to create and receive VLAN tagged ethernet
// traffic. Mainly used for test purposes.
//
// @see ~VlanEtherTrafGen
//
module VlanEtherHostQ
{
    parameters:
        @display("i=device/pc2;bgb=483,473");
        @networkNode();
        @labels(node,ethernet-node);
        //*.interfaceTableModule = default("");
        *.interfaceTableModule = default(absPath(".interfaceTable"));
        eth.mac.queueModule = "^.^.eth[0].queuing.transmissionSelection";
        eth.queuing.tsAlgorithms[*].macModule = "^.^.^.eth[0].mac";
        eth.queuing.gateController.macModule = "^.^.^.eth[0].mac";
        // extra wireless parameters:
        string energySourceModule = default("");
        **.energySourceModule = default(absPath(energySourceModule));
        string mobilityType = default("");
        **.mobilityModule = default(absPath(".mobility"));
    gates:
        //inout ethg @labels(EtherFrame-conn);
        //input ethg @labels(ISignal);
        
        input radioIn[1] @directIn;
    submodules:
        trafGenApp: VlanEtherTrafGen {
            @display("p=232,70");
        }
        //eth: <default("EthernetInterface")> like IEthernetInterface {
        wlan[1]: <default("Ieee80211Interface")> like IWirelessInterface {
        //Another option: "WirelessInterface", but then you have to specify
        //parameters like 'mib' if you use "Ieee80211Mac" instead of, say, "CsmaCaMac"
            
            parameters:
                @display("p=232,283,row,150;q=txQueue");
                encap.typename = "EtherEncap";
                qEncap.typename = "EnhancedIeee8021qEncap";
                
                //mac.typename = "EtherMacFullDuplex";
                
                mac.typename = "Ieee80211Mac";  // Another option: "CsmaCaMac",
                mac.mtu = 1500B;
                // extra wireless parameters:
                //radio.typename = "Ieee80211Radio";
        }
        interfaceTable: InterfaceTable {
            @display("p=53,164;is=s");
        }
        mobility: <default("StationaryMobility")> like IMobility {
        	@display("p=53,200");
        }
    //connections:
    connections allowunconnected:
        radioIn[0] --> wlan[0].radioIn;
        wlan[0].upperLayerOut --> trafGenApp.in;
        wlan[0].upperLayerIn <-- trafGenApp.out;
        //eth.phys <--> ethg;
        
}
