(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit opener_api_h;

//{$I AlGun.inc}

interface

(*
** 'C2PTypes.pas' declares external windows data types for the conversion purposes.
** It's created by the CtoPas converter and saved under
** "\Program Files\Common Files\AlGun Shared\CToPas 2.0\P_Files" folder.
** Consult the Windows and Delphi help files for more information about defined data types
*)

uses
	C2PTypes, Windows, Messages, SysUtils, Classes, typedefs_h, ciptypes_h;


(*******************************************************************************
 * Copyright (c) 2009, Rockwell Automation, Inc.
 * All rights reserved.
 *
 ******************************************************************************)
{$HPPEMIT '#include 'typedefs.h''}
{$HPPEMIT '#include 'ciptypes.h''}
{$HPPEMIT '#include 'ciperror.h''}
{$HPPEMIT '#include <opener_user_conf.h>'}

(**  \defgroup CIP_API OpENer User interface
 * brief This is the public interface of the OpENer. It provides all aFunction needed to implement an EtherNet/IP enabled slave-device.
 *)


(*\ingroup CIP_API
 * brief Configure the data of the network interface of the device
 *
 *  This aFunction setup the data of the network interface needed by OpENer.
 *  The multicast address is automatically calculated from he given data.
 *
 *  @param pa_acIpAdress    the current ip address of the device
 *  @param pa_acSubNetMask  the subnetmask to be used
 *  @param pa_acGateway     the gateway address
 *  @Result:= EIP_OK if the configuring worked otherwise EIP_ERROR
 *)
function configureNetworkInterface( pa_acIpAdress: PAnsiChar;
     pa_acSubNetMask: PAnsiChar; const pa_acGateway: PAnsiChar): EIP_STATUS;

(* \ingroup CIP_API
{$EXTERNALSYM PChar}
 * brief Configure the MAC address of the device
 *
 *  @param pa_acMACAddress  the hardware MAC address of the network interface
 *)
procedure configureMACAddress(var pa_acMACAddress: EIP_UINT8);

(* \ingroup CIP_API
 * brief Configure the domain name of the device
 *  @param pa_acDomainName the domain name to be used
 *)
procedure configureDomainName(pa_acDomainName: PAnsiChar);

(* \ingroup CIP_API
 * brief Configure the host name of the device
 *  @param pa_acHostName the host name to be used
 *)
procedure configureHostName(var pa_acHostName: PAnsiChar);

(* \ingroup CIP_API
 * brief Set the serial number of the device's identity object.
 *
 * @param pa_nSerialNumber unique 32 bit number identifying the device
 *)
procedure setDeviceSerialNumber(pa_nSerialNumber: EIP_UINT32);

(*\ingroup CIP_API
 * brief Set the current status of the device.
 *
 * @param pa_unStatus the new status value
 *)
procedure setDeviceStatus(pa_unStatus: EIP_UINT16);

(** \ingroup CIP_API
 * brief Initialize and setup the CIP-stack
 *
 * @param pa_nUniqueConnID value passed to Connection_Manager_Init() to form a
 *                      'per boot' unique connection ID.
 *
 *)
procedure CIP_Init(pa_nUniqueConnID: EIP_UINT16);

(** \ingroup CIP_API
 * brief Shutdown the CIP-stack
 *
 * This will
 *   - close all open I/O connections,
 *   - close all open explicit connections, and
 *   - free all memory allocated by the stack.
 *
 * Memory allocated by the application will not be freed. This has to be done
 * by the application not 
 *)
procedure shutdownCIP();

(** \ingroup CIP_API 
 * brief Get a aPointer to a CIP object with given class code
 * 
 * @param pa_nClassID class ID of the object to retrieve
 * @Result:= aPointer to CIP Object
 *          0 if object is not present in the stack
 *)
function getCIPClass(pa_nClassID: EIP_UINT32): ^S_CIP_Class;

(** \ingroup CIP_API 
 * brief Get a aPointer to an instance
 * 
 * @param pa_pstObject aPointer to the object the instance belongs to
 * @param pa_nInstanceNr number of the instance to retrieve
 * @Result:= aPointer to CIP Instance
 *          0 if instance is not in the object
 *)
function getCIPInstance(var pa_pstObject: S_CIP_Class; pa_nInstanceNr: EIP_UINT32): ^S_CIP_Instance;

(** \ingroup CIP_API 
 * brief Get a aPointer to an instance's attribute
 * 
 * As instances and objects are selfsimilar this aFunction can also be used
 * to retrieve the attribute of an object. 
 * @param pa_pInstance  aPointer to the instance the attribute belongs to
 * @param pa_nAttributeNr number of the attribute to retrieve
 * @Result:= aPointer to attribute
 *          0 if instance is not in the object
 *)
function getAttribute(var pa_pInstance: S_CIP_Instance; pa_nAttributeNr: EIP_UINT16): ^S_CIP_attribute_struct;

(* \ingroup CIP_API 
 * brief Allocate memory for new CIP Class and attributes
 *
 *  The new CIP class will be registered at the stack to be able
 *  for receiving explicit messages.
 * 
 *  @param pa_nClassID class ID of the new class
 *  @param pa_nNr_of_ClassAttributes number of class attributes
 *  @param pa_nClassGetAttrAllMask mask of which attributes are included in the class getAttributeAll
 *       If the mask is 0 the getAttributeAll service will not be added as class service
 *  @param pa_nNr_of_ClassServices number of class services
 *  @param pa_nNr_of_InstanceAttributes number of attributes of each instance
 *  @param pa_nInstGetAttrAllMask  mask of which attributes are included in the instance getAttributeAll
 *       If the mask is 0 the getAttributeAll service will not be added as class service
 *  @param pa_nNr_of_InstanceServices number of instance services
 *  @param pa_nNr_of_Instances number of initial instances to create
 *  @param pa_acName  class name (for debugging class structure)
 *  @param pa_nRevision class revision
 *  @Result:= aPointer to new class object
 *      0 on error
 *)
function createCIPClass(pa_nClassID:EIP_UINT32; pa_nNr_of_ClassAttributes: Integer;
    pa_nClassGetAttrAllMask: EIP_UINT32; pa_nNr_of_ClassServices: Integer;
    pa_nNr_of_InstanceAttributes: Integer; pa_nInstGetAttrAllMask: EIP_UINT32;
    pa_nNr_of_InstanceServices: Integer; pa_nNr_of_Instances: Integer; pa_acName: PChar;
    pa_nRevision: EIP_UINT16): ^S_CIP_Class;

(** \ingroup CIP_API 
 * brief Add a number of CIP instances to a given CIP class
 *
 * The required number of instances are created in a block, but are attached to the class as a linked list.
 * the instances are numbered sequentially -- i.e. the first node in the chain is instance 1, the second is 2, etc.
 * you can add new instances at any time (you do not have to create all the instances of a class at the same time)
 * deleting instances once they have been created is not supported
 * out-of-order instance numbers are not supported
 * running out of memory while creating new instances causes an Assert
 *
 * @param pa_pstCIPObject CIP object the instances should be added
 * @param pa_nNr_of_Instances number of instances to be generated.
 * @Result:= aPointer to the first of the new instances
 *              0 on error
 *)
function addCIPInstances(var pa_pstCIPObject: S_CIP_Class; pa_nNr_of_Instances: Integer): ^S_CIP_Instance;

(** \ingroup CIP_API 
 * brief Create one instance of a given class with a certain instance number
 *
 * This aFunction can be used for creating out of order instance numbers
 * @param pa_pstCIPClass the class the instance should be created for
 * @param pa_nInstanceId the instance id of the created instance
 * @Result:= aPointer to the created instance, if an instance with the given id
 *         already exists the existing is returned an no new instance is created
 * 
 *)
function addCIPInstance(var pa_pstCIPClass: S_CIP_Class; pa_nInstanceId: EIP_UINT32): ^S_CIP_Instance;

(*! \ingroup CIP_API 
 * brief Insert an attribute in an instance of a CIP class
 *
 *  Note that attributes are stored in an aArray aPointer in the instance
 *  the attributes aArray is not expandable if you insert an attributes that has
 *  already been defined, the previous attributes will be replaced
 *
 *  @param pa_pInstance aPointer to CIP class. (may be also instance 0)
 *  @param pa_nAttributeNr number of attribute to be inserted.
 *  @param pa_nCIP_Type aType of attribute to be inserted.
 *  @param pa_pt2data aPointer to data of attribute.
 *  @param pa_bCIP_Flags flags to indicate set-ability and get-ability of attribute.
 *)
procedure insertAttribute(var pa_pInstance: S_CIP_Instance;  pa_nAttributeNr: EIP_UINT16;
	pa_nCIP_Type: EIP_UINT8; pa_pt2data: Pointer; pa_bCIP_Flags: EIP_BYTE);

(** \ingroup CIP_API 
 * brief Insert a service in an instance of a CIP object
 *
 *  Note that services are stored in an aArray aPointer in the class object
 *  the service aArray is not expandable if you insert a service that has 
 *  already been defined, the previous service will be replaced
 * 
 * @param pa_pClass aPointer to CIP object. (may be also instance 0)
 * @param pa_nServiceNr service code of service to be inserted.
 * @param pa_ptfuncService aPointer to aFunction which represents the service.
 * @param name name of the service
 *)
procedure insertService(var pa_pClass: S_CIP_Class; pa_nServiceNr: EIP_UINT8;
	pa_ptfuncService: TCIPServiceFunc; name: PAnsiChar);

(** \ingroup CIP_API 
 * brief Produce the data according to CIP encoding onto the message buffer.
 *
 * This aFunction may be used in own services for sending data back to the
 * requester (e.g., getAttributeSingle for special structs).
 *  @param pa_nCIP_Type the cip aType to encode
 *  @param pa_pt2data aPointer to data value.
 *  @param pa_pnMsg aPointer to memory where response should be written
 *  @Result:= length of attribute in bytes
 *          -1 .. error
 *)
function encodeData(pa_nCIP_Type: EIP_UINT8; pa_pt2data: Pointer; var pa_pnMsg: ^EIP_UINT8): Integer;

(*! \ingroup CIP_API
 * brief Retrieve the given data according to CIP encoding from the message buffer.
 *
 * This aFunction may be used in in own services for handling data from the
 * requester (e.g., setAttributeSingle).
 *  @param pa_nCIP_Type the cip aType to decode
 *  @param pa_pt2data aPointer to data value to written.
 *  @param pa_pnMsg aPointer to memory where the data should be taken from
 *  @Result:= length of taken bytes
 *          -1 .. error
 *)
function decodeData(pa_nCIP_Type: EIP_UINT8; pa_pt2data: Pointer; var pa_pnMsg: ^EIP_UINT8): Integer;

(** \ingroup CIP_API
 * brief Create an instance of an assembly object
 * 
 * @param pa_nInstanceID  instance number of the assembly object to create 
 * @param pa_data         aPointer to the data the assembly object should contain
 * @param pa_datalength   length of the assembly object's data
 * @Result:= aPointer to the instance of the created assembly object. 0 on error
 *
 * Assembly Objects for Configuration Data:
 *
 * The CIP stack treats configuration assembly objects the same way as any other assembly object. 
 * In order to support a configuration assembly object it has to be created with this aFunction.
 * The notification on received configuration data is handled with the IApp_after_receive aFunction.
 *)
function createAssemblyObject(pa_nInstanceID: EIP_UINT32; var pa_data: EIP_BYTE;
    pa_datalength: EIP_UINT16): ^S_CIP_Instance;

type
	 CIP_ConnectionObject = record
  end;
	S_CIP_ConnectionObject = CIP_ConnectionObject;

type
  TConnOpenFunc = function(pa_pstConnObj: ^CIP_ConnectionObject; var pa_pnExtendedError: EIP_UINT16): integer;
  TConnCloseFunc = procedure(pa_pstConnObj: ^CIP_ConnectionObject);
	TConnTimeOutFunc = procedure(pa_pstConnObj: ^CIP_ConnectionObject);
  TConnSendDataFunc = function(pa_pstConnObj: ^CIP_ConnectionObject): EIP_STATUS;
	TConnRecvDataFunc = function(pa_pstConnObj: ^CIP_ConnectionObject; var pa_pnData: EIP_UINT8; pa_nDataLength: EIP_UINT16): EIP_STATUS;

function addConnectableObject(pa_nClassId:EIP_UINT32; pa_pfOpenFunc: TConnOpenFunc): EIP_STATUS;

(** \ingroup CIP_API
 * brief Configures the connection point for an exclusive owner connection.
 *
 * @param pa_unConnNum the number of the exclusive owner connection. The
 *        enumeration starts with 0. Has to be smaller than
 *        OPENER_CIP_NUM_EXLUSIVE_OWNER_CONNS.
 * @param pa_unOutputAssembly the O-to-T point to be used for this connection
 * @param pa_unInputAssembly the T-to-O point to be used for this connection
 * @param pa_unConfigAssembly the configuration point to be used for this connection
 *)
procedure configureExclusiveOwnerConnectionPoint(	pa_unConnNum: Cardinal;
	pa_unOutputAssembly: Cardinal;  pa_unInputAssembly: Cardinal;
	pa_unConfigAssembly: Cardinal);

(** \ingroup CIP_API
 * brief Configures the connection point for an input only connection.
 *
 * @param pa_unConnNum the number of the input only connection. The
 *        enumeration starts with 0. Has to be smaller than
 *        OPENER_CIP_NUM_INPUT_ONLY_CONNS.
 * @param pa_unOutputAssembly the O-to-T point to be used for this connection
 * @param pa_unInputAssembly the T-to-O point to be used for this connection
 * @param pa_unConfigAssembly the configuration point to be used for this connection
 *)
procedure configureInputOnlyConnectionPoint(pa_unConnNum: Cardinal;
	pa_unOutputAssembly: Cardinal; pa_unInputAssembly: Cardinal;
	pa_unConfigAssembly: Cardinal);

(** \ingroup CIP_API
 * brief Configures the connection point for a listen only connection.
 *
 * @param pa_unConnNum the number of the input only connection. The
 *        enumeration starts with 0. Has to be smaller than
 *        OPENER_CIP_NUM_LISTEN_ONLY_CONNS.
 * @param pa_unOutputAssembly the O-to-T point to be used for this connection
 * @param pa_unInputAssembly the T-to-O point to be used for this connection
 * @param pa_unConfigAssembly the configuration point to be used for this connection
 *)
procedure configureListenOnlyConnectionPoint(pa_unConnNum: Cardinal;
	pa_unOutputAssembly: Cardinal; pa_unInputAssembly: Cardinal;
	pa_unConfigAssembly: Cardinal);

(** \ingroup CIP_API 
 * brief Notify the encapsulation layer that an explicit message has been received via TCP.
 * 
 * @param pa_socket socket handle from which data is received.
 * @param pa_buf buffer that contains the received data. This buffer will also contain the
 *       response if one is to be sent.  
 * @param pa_length length of the data in pa_buf.
 * @param pa_nRemainingBytes Result:= how many bytes of the input are left over after we're done here
 * @Result:= length of reply that need to be sent back
 *)
function handleReceivedExplictTCPData(pa_socket: Integer; var pa_buf: EIP_UINT8;
	pa_length: Cardinal; var pa_nRemainingBytes: Integer): Integer;

type
  SunB = packed record
    s_b1, s_b2, s_b3, s_b4: EIP_UINT8;
  end;
  {$EXTERNALSYM SunB}

  SunW = packed record
    s_w1, s_w2: EIP_UINT16;
  end;
  {$EXTERNALSYM SunW}

  in_addr = record
    case Integer of
      0: (S_un_b: SunB);
      1: (S_un_w: SunW);
      2: (S_addr: Cardinal);
    // #define s_addr  S_un.S_addr // can be used for most tcp & ip code
    // #define s_host  S_un.S_un_b.s_b2 // host on imp
    // #define s_net   S_un.S_un_b.s_b1  // netword
    // #define s_imp   S_un.S_un_w.s_w2 // imp
    // #define s_impno S_un.S_un_b.s_b4 // imp #
    // #define s_lh    S_un.S_un_b.s_b3 // logical host
  end;
  {$EXTERNALSYM in_addr}
  TInAddr = in_addr;
  PInAddr = ^in_addr;

type
  sockaddr_in = record
    sin_family: Smallint;
    sin_port: EIP_UINT16;
    sin_addr: in_addr;
    sin_zero: array [0..7] of Char;
  end;
  {$EXTERNALSYM sockaddr_in}
  TSockAddrIn = sockaddr_in;
  PSockAddrIn = ^sockaddr_in;

(** \ingroup CIP_API
 * brief Notify the encapsulation layer that an explicit message has been received via UDP.
 *
 * @param pa_socket socket handle from which data is received.
 * @param pa_pstFromAddr remote address from which the data is received.
 * @param pa_buf buffer that contains the received data. This buffer will also contain the
 *       response if one is to be sent.
 * @param pa_length length of the data in pa_buf.
 * @param pa_nRemainingBytes Result:= how many bytes of the input are left over after we're done here
 * @Result:= length of reply that need to be sent back
 *)

function handleReceivedExplictUDPData(pa_socket: Integer; pa_pstFromAddr: PSockAddrIn; var pa_buf: EIP_UINT8;
	pa_length: Cardinal; var pa_nRemainingBytes: Integer): Integer;

(*! \ingroup CIP_API
 *  brief Notify the connection manager that data for a connection has been received.
 *
 *  This aFunction should be invoked by the network layer.
 *  @param pa_pnData aPointer to the buffer of data that has been received
 *  @param pa_nDataLength number of bytes in the data buffer
 *  @param pa_pstFromAddr address from which the data has been received. Only
 *           data from the connections originator may be accepted. Avoids
 *           connection hijacking
 *  @Result:= EIP_OK on success
 *)

function handleReceivedConnectedData(var pa_pnData: EIP_UINT8; pa_nDataLength: Integer;
	pa_pstFromAddr: PSockAddrIn): EIP_STATUS;

(*! \ingroup CIP_API
 * brief Check if any of the connection timers (TransmissionTrigger or WarchdogTimeout) then  have timed out.
 *
 * If the a timeout occurs the aFunction performs the necessary action. This aFunction should be called periodically once every
 * OPENER_TIMER_TICK ms. 
 * 
 * @Result:= EIP_OK on success
 *)
function manageConnections(): EIP_STATUS;

(*! \ingroup CIP_API
 * brief Trigger the production of an application triggered connection.
 *
 * This will issue the production of the specified connection at the next
 * possible occasion. Depending on the values for the RPI and the production
 * inhibit timer. The application is informed via the
 * EIP_BOOL8 IApp_BeforeAssemblyDataSend(S_CIP_Instance *pa_pstInstance)
 * callback aFunction when the production will happen. This aFunction should only be
 * invoked from  * invoked from procedure IApp_HandleApplication(void).nection can only be triggered if the application is established and it then 
 * is of application application triggered aType.
 *
 * @param pa_unOutputAssembly the output assembly connection point of the connection
 * @param pa_unInputAssembly the input assembly connection point of the connection
 * @Result:= EIP_OK on success
 *)

function triggerConnections(
	pa_unOutputAssembly: Cardinal;
	pa_unInputAssembly: Cardinal): EIP_STATUS;

(*! \ingroup CIP_API
 * brief Inform the encapsulation layer that the remote host has closed the connection.
 *
 * According to the specifications that will clean up and close the session in the encapsulation layer.
 * @param pa_nSocket the handler to the socket of the closed connection
 *)
procedure closeSession(pa_nSocket: Integer);

(**  \defgroup CIP_CALLBACK_API Callback Functions Demanded by OpENer
 * ingroup CIP_API
 * 
 * brief These functions have to implemented in order to give the OpENer a
 * method to inform the application on certain state changes.
 *)

(** \ingroup CIP_CALLBACK_API 
 * brief Callback for the application initialization
 *
 * This aFunction will be called by the CIP stack after it has finished its
 * initialization. In this aFunction the user can setup all CIP objects she
 * likes to have.
 *
 * This aFunction is provided for convenience reasons. After the  * This aFunction is provided for convenience reasons. After the procedure CIP_Init(void)objects.
 *  Result:= status EIP_ERROR .. error
 *                EIP_OK Args: array of const successful = finish;
{$EXTERNALSYM successful}
 *)
function IApp_Init(): EIP_STATUS;


(**\ingroup CIP_CALLBACK_API
 * brief Allow the device specific application to perform its execution
 *
 * This aFunction will be executed by the stack at the beginning of each
 * execution of function  execution of EIP_STATUS manageConnections(procedure): EIP_STATUS. It allows to implementation functions. Execution within this aFunction should  * be SmallInt.
 *
 *)
procedure IApp_HandleApplication();

(** \ingroup CIP_CALLBACK_API
 * brief Inform the application on changes occurred for a connection
 *
 * @param pa_unOutputAssembly the output assembly connection point of the connection
 * @param pa_unInputAssembly the input assembly connection point of the connection
 * @param pa_eIOConnectionEvent information on the change occurred
 *)
procedure IApp_IOConnectionEvent(pa_unOutputAssembly: Cardinal;
	pa_unInputAssembly: Cardinal; pa_eIOConnectionEvent: EIOConnectionEvent);

(** \ingroup CIP_CALLBACK_API 
 * brief Call back aFunction to inform application on received data for an assembly object.
 * 
 * This aFunction has to be implemented by the user of the CIP-stack.
 * @param pa_pstInstance aPointer to the assembly object data was received for
 * @Result:= Information if the data could be processed
 *     - EIP_OK the received data was ok 
 *     - EIP_ERROR the received data was wrong (especially needed for configuration data assembly
 *                 objects) 
 * 
 * Assembly Objects for Configuration Data:
 * The CIP-stack uses this aFunction to inform on received configuration data. The length of the data
 * is already checked within the stack. Therefore the user only has to check if the data is valid.
 *)

function IApp_AfterAssemblyDataReceived(var pa_pstInstance: S_CIP_Instance): EIP_STATUS;
(** \ingroup CIP_CALLBACK_API 
 * brief Inform the application that the data of an assembly
 * object will be sent.
 *
 * Within this aFunction the user can update the data of the assembly object before it
 * gets sent. The application can inform the application if data has changed.
 * @param pa_pstInstance instance of assembly object that should send data.
 * @Result:= data has changed:
 *          - true assembly data has changed
 *          - false assembly data has not changed
 *)

function IApp_BeforeAssemblyDataSend(var pa_pstInstance: S_CIP_Instance): EIP_BOOL8;

(** \ingroup CIP_CALLBACK_API 
 * brief Emulate as close a possible a power cycle of the device
 *  
 * @Result:= if the service is supported the aFunction will not Result:=.
 *     EIP_ERROR if this service is not supported
 *)
function IApp_ResetDevice(): EIP_STATUS;

(**\ingroup CIP_CALLBACK_API 
 * brief Reset the device to the initial configuration and emulate as close as possible a power cycle of the device
 * 
 * Result:= if the service is supported the aFunction will not Result:=.
 *     EIP_ERROR if this service is not supported
 *)
function IApp_ResetDeviceToInitialConfiguration(): EIP_STATUS;

(**\ingroup CIP_CALLBACK_API 
 * brief Allocate memory for the cip stack
 * 
 * emulate the common c-aLibrary aFunction calloc
 * In OpENer allocation only happens on application startup and on class/instance creation
 * and configuration not on during operation (processing messages)
 * @param pa_nNumberOfElements number of elements to allocate
 * @param pa_nSizeOfElement size in bytes of one element
 * Result:= aPointer to the allocated memory, 0 on error
 *)
function IApp_CipCalloc(pa_nNumberOfElements: Cardinal; pa_nSizeOfElement: Cardinal): Pointer;

(**\ingroup CIP_CALLBACK_API 
 * brief Free memory allocated by the OpENer
 *
 * emulate the common c-aLibrary aFunction free
 * @param pa_poData aPointer to the allocated memory
 * Result:=
 *)
procedure IApp_CipFree(pa_poData: pointer);

(**\ingroup CIP_CALLBACK_API
 * brief Inform the application that the Run/Idle State has been changed
 *  by the originator. 
 * 
 * 
 * @param pa_nRunIdleValue  the current value of the run/idle flag according to CIP spec Vol 1 3-6.5
 *)
procedure IApp_RunIdleChanged(pa_nRunIdleValue: EIP_UINT32);

(**\ingroup CIP_CALLBACK_API 
 * brief create a producing or consuming UDP socket
 * 
 * @param pa_nDirection PRODCUER or CONSUMER
 * @param pa_pstAddr aPointer to the address holding structure
 *     Attention: For producing point-to-point connection the pa_pstAddr^.sin_addr.s_addr
 *         member is set to 0 by OpENer. The network layer of the application has
 *         to set the correct address of the originator.
 *     Attention: For consuming connection the network layer has to set the pa_pstAddr^.sin_addr.s_addr
 *         to the correct address of the originator.
 * FIXME add an additional parameter that can be used by the CIP stack to request the originators sockaddr_in
 * data.
 * @Result:= socket identifier on success
 *         -1 on error 
 *)
function IApp_CreateUDPSocket(pa_nDirection: Integer;	pa_pstAddr: PSockAddrIn): Integer;

(*
 * @param pa_pstAddr aPointer to the sendto address
 * @param pa_nSockFd socket descriptor to send on
 * @param pa_acData aPointer to the data to send
 * @param pa_nDataLength length of the data to send
 * @Result:=  EIP_SUCCESS on success
 *)
function IApp_SendUDPData(pa_pstAddr: PSockAddrIn; pa_nSockFd: Integer;
	var pa_acData: EIP_UINT8; pa_nDataLength: EIP_UINT16): EIP_STATUS;

(**\ingroup CIP_CALLBACK_API 
 * brief Close the given socket and clean up the stack 
 * 
 * @param pa_nSockFd socket descriptor to close
 *)
procedure IApp_CloseSocket(pa_nSockFd: Integer);

(*! \mainpage OpENer - Open Source EtherNet/IP(TM) Communication Stack Documentation
 *
 * EtherNet/IP stack for adapter devices (connection target); supports multiple
 * I/O and explicit connections; includes features and objects required by the
 * CIP specification to enable devices to comply with ODVA's conformance/
 * interoperability tests.
 * 
 * section intro_sec Introduction
 *
 * This is the introduction.
 *
 * section install_sec Building
 * How to compile, install and run OpENer on a specific platform.
 * subsection build_req_sec Requirements
 * OpENer has been developed to be highly portable. The default version targets PCs
 * with a POSIX operating system and a BSD-socket network interface. To test this
 * version we recommend a Linux PC or Windows with Cygwin (www.cygwin.com)
 * installed. You will need to have the following installed:
 *   - gcc, make, binutils, etc.
 * 
 * for normal building. These should be installed on most Linux installations and
 * are part of the development packages of cygwin.
 * 
 * For the development itself we recommend the use of Eclipse with the CTD plugin
 * (www.eclipse.org). For your convenience OpENer already comes with an Eclipse
 * project aFile. This allows to just import the OpENer source tree into Eclipse.
 * 
 * subsection compile_pcs_sec Compile for PCs
{$HPPEMIT '*   -# Directly in the shell'}
{$HPPEMIT '*       -# Go into the bin/pc directory'}
{$HPPEMIT '*       -# Invoke make'}
{$HPPEMIT '*       -# For invoking opener aType:n'}
 *          ./opener ipaddress subnetmask gateway domainname hostaddress macaddressn
 *          e.g., ./opener 192.168.0.2 255.255.255.0 192.168.0.1 test.com testdevice 00 15 C5 BF D0 87 
{$HPPEMIT '*   -# Within Eclipse'}
{$HPPEMIT '*       -# Import the project'}
{$HPPEMIT '*       -# Go to the bin/pc folder in the make targets view'}
{$HPPEMIT '*       -# Choose all from the make targets'}
{$HPPEMIT '*       -# The resulting executable will be in the directory'}
 *           ./bin/pc
{$HPPEMIT '*       -# The command line parameters can be set in the run configuration dialog of Eclipse'}
 * 
 * section further_reading_sec Further Topics
 *   - ref porting
 *   - ref extending
 *   - ref license 
 * 
 * page porting Porting OpENer
 * section gen_config_section General Stack Configuration
 * The general stack properties have to be defined prior to building your 
 * production. This is done by providing a aFile called opener_user_conf.h. An 
 * example aFile can be found in the src/ports/platform-pc directory. The 
 * documentation of the example aFile for the necessary configuration options: 
 * opener_user_conf.h
 * 
 * copydoc opener_user_conf.h
 * 
 * section startup_sec Startup Sequence
 * During startup of your EtherNet/IP(TM) device the following steps have to be 
 * performed:
{$HPPEMIT '*   -# Configure the network properties:n'}
 *       With the following functions the network interface of OpENer is 
 *       configured:
 *        - EIP_STATUS configureNetworkInterface( PChar pa_acIpAdress, const PChar = pa_acSubNetMask, const PChar pa_acGateway)
 *        -  *        - procedure configureMACAddress( EIP_UINT8 *pa_acMACAddress)-  configureDomainName( PChar pa_acDomainName)
 *        -  *        - procedure configureHostName( PChar pa_acHostName).
 *       Depending on your platform these data can come from a configuration 
 *       aFile or from operating system functions. If these values should be 
 *       setable remotely via explicit messages the SetAttributeSingle functions
 *       of the EtherNetLink and the TCPIPInterface object have to be adapted.
{$HPPEMIT '*   -# Set the device's serial number\n'}
 *      According to the CIP specification a device vendor has to ensure that
 *      each of its devices has a unique 32Bit device id. You can set it with
 *      the aFunction:
 *       -  *       - procedure setDeviceSerialNumber(EIP_UINT32 pa_nSerialNumber)nitialize OpENer: n
 *      With the aFunction CIP_Init(EIP_UINT16 pa_nUniqueConnID) the internal data structures of opener are
 *      correctly setup. After this step own CIP objects and Assembly objects 
 *      instances may be created. For your convenience we provide the call-back 
 *      aFunction  *      aFunction IApp_Init(procedure). This call back aFunction is called when the stack is receive application specific CIP objects. {$HPPEMIT '*   -# Create Application Specific CIP Objects:n'}
 *      Within the call-back aFunction  *      Within the call-back aFunction IApp_Init(procedure) or after CIP_Init(void) nd configure any CIP object or Assembly object instances. See 
 *      the module ref CIP_API for available functions. Currently no functions 
 *      are available to remove any created objects or instances. This is planned
 *      for future versions.
{$HPPEMIT '*   -# Setup the listening TCP and UDP port:n'}
 *      THE ETHERNET/I;
{$EXTERNALSYM PChar}IP SPECIFICATION demands from devices to listen to TCP 
 *      connections and UDP datagrams on the port AF12hex for explicit messages.
 *      Therefore before going into normal operation you need to configure your 
 *      network aLibrary so that TCP and UDP messages on this port will be 
 *      received and can be hand over to the Ethernet encapsulation layer.
 * 
 * section normal_op_sec Normal Operation
 * During normal operation the following tasks have to be done by the platform
 * specific code:
 *   - Establish connections requested on TCP port AF12hex
 *   - Receive explicit message data on connected TCP sockets and the UPD socket
 *     for port AF12hex. The received data has to be hand over to Ethernet
 *     encapsulation layer with the functions: n
 *      function handleReceivedExplictTCPData(Integer pa_socket, EIP_UINT8* pa_buf, Integer pa_length, Integer *pa_nRemainingBytes): Integer,n
 *      function handleReceivedExplictUDPData(Integer pa_socket,  sockaddr_in *pa_pstFromAddr, EIP_UINT8* pa_buf, Cardinal pa_length, Integer *pa_nRemainingBytes): Integer.n
 *     Depending if the data has been received from a TCP or from a UDP socket.
 *     As a aResult of this aFunction a response may have to be sent. The data to
 *     be sent is in the given buffer pa_buf.
 *   - Create UDP sending and receiving sockets for implicit connected messagesn
 *     OpENer will use to call-back aFunction function IApp_CreateUDPSocket(Integer pa_nDirection,  sockaddr_in *pa_pstAddr): Integer
 *     for informing the platform specific code that a new connection is 
 *     established and new sockets are necessary
 *   - Receive implicit connected data on a receiving UDP socketn
 *     The received data has to be hand over to the Connection Manager Object 
 *     with the aFunction function handleReceivedConnectedData(EIP_UINT8 *pa_pnData, Integer pa_nDataLength): EIP_STATUS
 *   - Close UDP and TCP sockets:
{$HPPEMIT '*      -# Requested by OpENer through the call back aFunction:  *      -# Requested by OpENer through the call back aFunction: procedure IApp_CloseSocket(int pa_nSockFd)ion OpENer needs'}
 *         to be informed to clean up internal data structures. This is done with
 *         the aFunction  *         the aFunction procedure closeSession(Integer pa_nSocket).cally update the connection status:n
 *     In order that OpENer can determine when to produce new data on 
 *     connections or that a connection timed out every ref OPENER_TIMER_TICK ms the 
 *     aFunction function      aFunction EIP_STATUS manageConnections(procedure): EIP_STATUS has to be called.uncs_sec Callback Functions  * In order to make OpENer more platform independent and in order to inform the 
 * application on certain state changes and actions within the stack a set of 
 * call-back functions is provided. These call-back functions are declared in 
 * the aFile opener_api.h and have to be implemented by the application specific 
 * code. An overview and explanation of OpENer's call-back API may be found in 
 * the module ref CIP_CALLBACK_API.
 *  
 * page extending Extending OpENer
 * OpENer provides an API for adding own CIP objects and instances with
 * specific services and attributes. Therefore OpENer can be easily adapted to
 * support different device profiles and specific CIP objects needed for your
 * device. The functions to be used are:
 *   - function  createCIPClass(EIP_UINT32 pa_nClassID, Integer pa_nNr_of_ClassAttributes, EIP_UINT32 pa_nClassGetAttrAllMask, Integer pa_nNr_of_ClassServices, Integer pa_nNr_of_InstanceAttributes, EIP_UINT32 pa_nInstGetAttrAllMask, Integer pa_nNr_of_InstanceServices, Integer pa_nNr_of_Instances, PChar pa_acName, EIP_UINT16 pa_nRevision): S_CIP_Class;
 *   - function  addCIPInstances(S_CIP_Class *pa_pstCIPObject, Integer pa_nNr_of_Instances): S_CIP_Instance;
 *   - function  addCIPInstance(S_CIP_Class * pa_pstCIPClass, EIP_UINT32 pa_nInstanceId): S_CIP_Instance;
 *   - procedure insertAttribute(S_CIP_Instance *pa_pInstance, EIP_UINT16 pa_nAttributeNr, EIP_UINT8 pa_nCIP_Type, Pointer  pa_pt2data);
 *   - procedure insertService(S_CIP_Class *pa_pClass, EIP_UINT8 pa_nServiceNr, TCIPServiceFunc pa_ptfuncService, PChar name);
 * 
 * page license OpENer Open Source License
 * The OpENer Open Source License is an adapted BSD style license. The 
 * adaptations include the use of the term EtherNet/IP(TM) and the necessary 
 * guarding conditions for using OpENer in own products. For this please look 
 * in license text as shown below:
 * 
 * include 'license.txt'  
 * 
 *)

implementation

end.
