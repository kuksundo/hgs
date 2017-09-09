(***************************************************************

 * Converted with C to Pascal Converter 2.0
 * Release: 2.1.7.2015

 * Email: uralgunaydin@gmail.com
 * Updates: https://www.facebook.com/groups/375400985981109/files/
 * Blogs: https://www.facebook.com/groups/375400985981109/

 * Copyright (c) 2005, 2015 Ural Gunaydin (a.k.a. Al Gun)

***************************************************************)

unit ciperror_h;

//{$I AlGun.inc}

interface

(*
** 'C2PTypes.pas' declares external windows data types for the conversion purposes.
** It's created by the CtoPas converter and saved under
** "\Program Files\Common Files\AlGun Shared\CToPas 2.0\P_Files" folder.
** Consult the Windows and Delphi help files for more information about defined data types
*)

uses
	C2PTypes, Windows, Messages, SysUtils, Classes;


(*******************************************************************************
 * Copyright (c) 2009, Rockwell Automation, Inc.
 * All rights reserved. 
 *
 ******************************************************************************)

const CIP_ERROR_SUCCESS = $00;	(*!< Service was successfully performed by the object specified. *)
{$EXTERNALSYM CIP_ERROR_SUCCESS}
const CIP_ERROR_CONNECTION_FAILURE = $01;	(*!< A connection related service failed along the connection path. *)
{$EXTERNALSYM CIP_ERROR_CONNECTION_FAILURE}
const CIP_ERROR_RESOURCE_UNAVAILABLE = $02;	(*!< Resources needed for the object to perform the requested service were unavailable *)
{$EXTERNALSYM CIP_ERROR_RESOURCE_UNAVAILABLE}
const CIP_ERROR_INVALID_PARAMETER_VALUE = $03;	(*!< See Status Code 0x20, which is the preferred value to use for this condition. *)
{$EXTERNALSYM CIP_ERROR_INVALID_PARAMETER_VALUE}
const CIP_ERROR_PATH_SEGMENT_ERROR = $04;	(*!< The path segment identifier or the segment syntax was not understood by the
processing node. Path processing shall stop when a path segment error is encountered. *)
{$EXTERNALSYM CIP_ERROR_PATH_SEGMENT_ERROR}
const CIP_ERROR_PATH_DESTINATION_UNKNOWN = $05;	(*!< The path is referencing an object class, instance or structure element that is not
known or is not contained in the processing node. Path processing shall stop when a path destination unknown error is encountered. *)
{$EXTERNALSYM CIP_ERROR_PATH_DESTINATION_UNKNOWN}
const CIP_ERROR_PARTIAL_TRANSFER = $06;	(*!< Only part of the expected data was transferred. *)
{$EXTERNALSYM CIP_ERROR_PARTIAL_TRANSFER}
const CIP_ERROR_CONNECTION_LOST = $07;	(*!< The messaging connection was lost. *)
{$EXTERNALSYM CIP_ERROR_CONNECTION_LOST}
const CIP_ERROR_SERVICE_NOT_SUPPORTED = $08;	(*!< The requested service was not implemented or was not defined for this Object
Class/I
{$EXTERNALSYM CIP_ERROR_SERVICE_NOT_SUPPORTED}Instance. *)
const CIP_ERROR_INVALID_ATTRIBUTE_VALUE = $09;	(*!< Invalid attribute data detected *)
{$EXTERNALSYM CIP_ERROR_INVALID_ATTRIBUTE_VALUE}
const CIP_ERROR_ATTRIBUTE_LIST_ERROR = $0A;	(*!< An attribute in the Get_Attribute_List or Set_Attribute_List response has a
non-zero status. *)
{$EXTERNALSYM CIP_ERROR_ATTRIBUTE_LIST_ERROR}
const CIP_ERROR_ALREADY_IN_REQUESTED_MODE = $0B;	(*!< The object is already in the mode/state being requested by the service *)
{$EXTERNALSYM CIP_ERROR_ALREADY_IN_REQUESTED_MODE}
const CIP_ERROR_OBJECT_STATE_CONFLICT = $0C;	(*!< The object cannot perform the requested service in its current mode/state *)
{$EXTERNALSYM CIP_ERROR_OBJECT_STATE_CONFLICT}
const CIP_ERROR_OBJECT_ALREADY_EXISTS = $0D;	(*!< The requested instance of object to be created already exists.*)
{$EXTERNALSYM CIP_ERROR_OBJECT_ALREADY_EXISTS}
const CIP_ERROR_ATTRIBUTE_NOT_SETTABLE = $0E;	(*!< A request to modify a non-modifiable attribute was received. *)
{$EXTERNALSYM CIP_ERROR_ATTRIBUTE_NOT_SETTABLE}
const CIP_ERROR_PRIVILEGE_VIOLATION = $0F;	(*!< A permission/privilege check failed *)
{$EXTERNALSYM CIP_ERROR_PRIVILEGE_VIOLATION}
const CIP_ERROR_DEVICE_STATE_CONFLICT = $10;	(*!< The device's current mode/state prohibits the execution of the requested service. */
{$EXTERNALSYM CIP_ERROR_DEVICE_STATE_CONFLICT}
const CIP_ERROR_REPLY_DATA_TOO_LARGE = $11;	(*!< The data to be transmitted in the response buffer is larger than the allocated response buffer *)
{$EXTERNALSYM CIP_ERROR_REPLY_DATA_TOO_LARGE}
const CIP_ERROR_FRAGMENTATION_OF_A_PRIMITIVE_VALUE = $12;	(*!< The service specified an operation that is going to fragment a primitive data
value, i.e. half a aReal data aType. *)
{$EXTERNALSYM CIP_ERROR_FRAGMENTATION_OF_A_PRIMITIVE_VALUE}
const CIP_ERROR_NOT_ENOUGH_DATA = $13;	(*!< The service did not supply enough data to perform the specified operation. *)
{$EXTERNALSYM CIP_ERROR_NOT_ENOUGH_DATA}
const CIP_ERROR_ATTRIBUTE_NOT_SUPPORTED = $14;	(*!< The attribute specified in the request is not supported *)
{$EXTERNALSYM CIP_ERROR_ATTRIBUTE_NOT_SUPPORTED}
const CIP_ERROR_TOO_MUCH_DATA = $15;	(*!< The service supplied more data than was expected *)
{$EXTERNALSYM CIP_ERROR_TOO_MUCH_DATA}
const CIP_ERROR_OBJECT_DOES_NOT_EXIST = $16;	(*!< The object specified does not exist in the device. *)
{$EXTERNALSYM CIP_ERROR_OBJECT_DOES_NOT_EXIST}
const CIP_ERROR_SERVICE_FRAGEMENTATION_SEQUENCE_NOT_IN_PROGRESS = $17;	(*!< The fragmentation sequence for this service is not currently active for this
data. *)
{$EXTERNALSYM CIP_ERROR_SERVICE_FRAGEMENTATION_SEQUENCE_NOT_IN_PROGRESS}
const CIP_ERROR_NO_STORED_ATTRIBUTE_DATA = $18;	(*!< The attribute data of this object was not saved prior to the requested service. *)
{$EXTERNALSYM CIP_ERROR_NO_STORED_ATTRIBUTE_DATA}
const CIP_ERROR_STORE_OPERATION_FAILURE = $19;	(*!< The attribute data of this object was not saved due to a failure during the attempt. *)
{$EXTERNALSYM CIP_ERROR_STORE_OPERATION_FAILURE}
const CIP_ERROR_ROUTING_FAILURE_REQUEST_PACKET_TOO_LARGE = $1A;	(*!< The service request packet was too large for transmission on a network in the
path to the destination. The routing device was forced to abort the service. *)
{$EXTERNALSYM CIP_ERROR_ROUTING_FAILURE_REQUEST_PACKET_TOO_LARGE}
const CIP_ERROR_ROUTING_FAILURE_RESPONSE_PACKET_TOO_LARGE = $1B;	(*!< The service response packet was too large for transmission on a network in the
path from the destination. The routing device was forced to abort the service. *)
{$EXTERNALSYM CIP_ERROR_ROUTING_FAILURE_RESPONSE_PACKET_TOO_LARGE}
const CIP_ERROR_MISSING_ATTIRBUTE_LIST_ENTRIY = $1C;	(*!< The service did not supply an attribute in a list of attributes that was needed by
the service to perform the requested behavior. *)
{$EXTERNALSYM CIP_ERROR_MISSING_ATTIRBUTE_LIST_ENTRIY}
const CIP_ERROR_INVALID_ATTRIBUTE_VALUE_LIST = $1D;	(*!< The service is returning the list of attributes supplied with status information
for those attributes that were invalid. *)
{$EXTERNALSYM CIP_ERROR_INVALID_ATTRIBUTE_VALUE_LIST}
const CIP_ERROR_EMBEDDED_SERVICE_ERROR = $1E;	(*!< An embedded service resulted in an error. *)
{$EXTERNALSYM CIP_ERROR_EMBEDDED_SERVICE_ERROR}
const CIP_ERROR_VENDOR_SPECIFIC_ERROR = $1F;	(*!< A vendor specific error has been encountered. The Additional Code Field of
the Error Response defines the particular error encountered. Use of this
General Error Code should only be performed when none of the Error Codes
presented in this table or within an Object Class definition accurately reflect
the error. *)
{$EXTERNALSYM CIP_ERROR_VENDOR_SPECIFIC_ERROR}
const CIP_ERROR_INVALID_PARAMETER = $20;	(*!< A parameter associated with the request was invalid. This code is used when a
parameter does not meet the requirements of this specification and/o
{$EXTERNALSYM CIP_ERROR_INVALID_PARAMETER}or the
requirements defined in an Application Object Specification. *)
const CIP_ERROR_WRITEONCE_VALUE_OR_MEDIUM_ALREADY_WRITTEN = $21;	(*!< An attempt was made to write to a write-once medium (e.g. WORM drive,
PROM) that has already been written, or to modify a value that cannot be changed once established. *)
{$EXTERNALSYM CIP_ERROR_WRITEONCE_VALUE_OR_MEDIUM_ALREADY_WRITTEN}
const CIP_ERROR_INVALID_REPLY_RECEIVED = $22;	(*!< An invalid reply is received (e.g. reply service code does not match the request
service code, or reply message is shorter than the minimum expected reply
size). This status code can serve for other causes of invalid replies. *)
{$EXTERNALSYM CIP_ERROR_INVALID_REPLY_RECEIVED}
(*23-24 Reserved by CIP for future extensions*)
const CIP_ERROR_KEY_FAILURE_IN_PATH = $25;	(*!< The Key Segment that was included as the first segment in the path does not
match the destination module. The object specific status shall indicate which part of the key check failed. *)
{$EXTERNALSYM CIP_ERROR_KEY_FAILURE_IN_PATH}
const CIP_ERROR_PATH_SIZE_INVALID = $26;	(*!< The size of the path which was sent with the Service Request is either not large
enough to allow the Request to be routed to an object or too much routing data was included. *)
{$EXTERNALSYM CIP_ERROR_PATH_SIZE_INVALID}
const CIP_ERROR_UNEXPECTED_ATTRIBUTE_IN_LIST = $27;	(*!< An attempt was made to set an attribute that is not able to be set at this time. *)
{$EXTERNALSYM CIP_ERROR_UNEXPECTED_ATTRIBUTE_IN_LIST}
const CIP_ERROR_INVALID_MEMBER_ID = $28;	(*!< The Member ID specified in the request does not exist in the specified Class/Instance/Attribute *)
{$EXTERNALSYM CIP_ERROR_INVALID_MEMBER_ID}
const CIP_ERROR_MEMBER_NOT_SETTABLE = $29;	(*!< A request to modify a non-modifiable member was received *)
{$EXTERNALSYM CIP_ERROR_MEMBER_NOT_SETTABLE}
const CIP_ERROR_GROUP2_ONLY_SERVER_GENERAL_FAILURE = $2A;	(*!< This error code may only be reported by DeviceNet group 2 only servers with
4K or less code space and only in place of Service not supported, Attribute
not supported and Attribute not settable. *)
{$EXTERNALSYM CIP_ERROR_GROUP2_ONLY_SERVER_GENERAL_FAILURE}
(*2B - CF Reserved by CIP for future extensions
 D0 - FF Reserved for Object Class and service errors*)

implementation

end.
