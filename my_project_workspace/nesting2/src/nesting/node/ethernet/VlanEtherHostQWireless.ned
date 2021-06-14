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

//import inet.linklayer.contract.IEthernetInterface;
import inet.networklayer.common.InterfaceTable;
import nesting.application.ethernet.VlanEtherTrafGen;
import nesting.common.time.IClock;
import nesting.common.time.IOscillator;
// my extra wireless packages:
import inet.linklayer.contract.IWirelessInterface;
import inet.mobility.contract.IMobility;


//
// @deprecated
//
// Simple Host with the capability to create and receive VLAN tagged ethernet
// traffic. Mainly used for test purposes.
//
// @see ~VlanEtherTrafGen
//
module VlanEtherHostQWireless
{
    parameters:
        @display("i=device/pc2;bgb=381,407");
        @networkNode();
        @labels(node,ethernet-node);
        **.clockModule = default(absPath(".legacyClock"));
        **.oscillatorModule = default(absPath(".oscillator"));
        **.interfaceTableModule = default(absPath(".interfaceTable"));
        
        // extra wireless parameters:
        string energySourceModule = default("");
        **.energySourceModule = default(absPath(energySourceModule));
        string mobilityType = default("");
        **.mobilityModule = default(absPath(".mobility"));
        
    gates:
        //inout ethg @labels(EtherFrame-conn);
        input radioIn[1] @directIn; // extra wireless line
    submodules:
        trafGenApp: VlanEtherTrafGen {
            @display("p=232,70");
        }
        oscillator: <default("IdealOscillator")> like IOscillator {
            @display("p=53,101;is=s");
        }
        legacyClock: <default("LegacyClock")> like IClock {
            @display("p=53,39;is=s");
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
