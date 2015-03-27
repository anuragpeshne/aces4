/*
 * distributed_block_consistency.cpp
 *
 *  Created on: Mar 27, 2015
 *      Author: njindal
 */

#include <distributed_block_consistency.h>

namespace sip {


DistributedBlockConsistency::DistributedBlockConsistency(){
	consistency_status_.first = NONE;
	consistency_status_.second = OPEN;
}

void DistributedBlockConsistency::reset_consistency_status (){
	CHECK(consistency_status_.first != INVALID_MODE &&
			consistency_status_.second != INVALID_WORKER,
			"Inconsistent block status !");
	consistency_status_.first = NONE;
	consistency_status_.second = OPEN;
}


bool DistributedBlockConsistency::update_and_check_consistency(SIPMPIConstants::MessageType_t operation, int worker){
	/**
	 * Block Consistency Rules
	 *
	 *     		  GET,w    PUT,w    PUT_ACC,w   GET,w1     PUT,w1  PUT_ACC,w1
	 *		NO      Rw      Ww         Aw         Rw1        Ww1     Aw1
	 *		Rw      Rw      Sw         Sw         RM          X       X
	 *		RM      RM       X          X          RM         X       X
	 *		Ww      Sw      Sw         Sw          X          X       X
	 *		Aw      Sw      Sw         Aw          X          X       AM
	 *		AM       X       X         AM          X          X       AM
	 *		Sw      Sw      Sw         Sw          X          X       X
	 */

	ServerBlockMode mode = consistency_status_.first;
	int prev_worker = consistency_status_.second;

	// Check if block already in inconsistent state.
	if (mode == INVALID_MODE || prev_worker == INVALID_WORKER)
		return false;


	ServerBlockMode new_mode = INVALID_MODE;
	int new_worker = INVALID_WORKER;

	switch (mode){
	case NONE: {
		/*  		  GET,w    PUT,w    PUT_ACC,w   GET,w1     PUT,w1  PUT_ACC,w1
		 *		NO      Rw      Ww         Aw         Rw1        Ww1     Aw1
		 */
		if (OPEN == prev_worker){
			switch(operation){
			case SIPMPIConstants::GET : 			new_mode = READ; 		new_worker = worker; break;
			case SIPMPIConstants::PUT : 			new_mode = WRITE; 		new_worker = worker; break;
			case SIPMPIConstants::PUT_ACCUMULATE :	new_mode = ACCUMULATE; 	new_worker = worker; break;
			default : goto consistency_error;
			}
		} else {
			goto consistency_error;
		}
	}
		break;
	case READ: {
		/*  		  GET,w    PUT,w    PUT_ACC,w   GET,w1     PUT,w1  PUT_ACC,w1
		 *		Rw      Rw      Sw         Sw         RM          X       X
		 *		RM      RM       X          X          RM         X       X
		 */
		if (OPEN == prev_worker){
			goto consistency_error;
		} else if (MULTIPLE_WORKER == prev_worker){
			switch(operation){
			case SIPMPIConstants::GET :				new_mode = READ; new_worker = MULTIPLE_WORKER; break;
			case SIPMPIConstants::PUT : case SIPMPIConstants::PUT_ACCUMULATE : {	goto consistency_error; } break;
			default : goto consistency_error;
			}
		} else { 	// Single worker
			switch(operation){
			case SIPMPIConstants::GET :	new_mode = READ; new_worker = (worker == prev_worker ? worker : MULTIPLE_WORKER); break;
			case SIPMPIConstants::PUT : case SIPMPIConstants::PUT_ACCUMULATE :{
				if (worker != prev_worker)
					goto consistency_error;
				new_mode = SINGLE_WORKER;
				new_worker = worker;
			}
			break;
			default : goto consistency_error;
			}
		}
	}
		break;
	case WRITE:{
		/*  		  GET,w    PUT,w    PUT_ACC,w   GET,w1     PUT,w1  PUT_ACC,w1
		 *		Ww      Sw      Sw         Sw          X          X       X
		 */
		if (prev_worker == worker){
			new_mode = SINGLE_WORKER; new_worker = worker;
		} else {
			goto consistency_error;
		}
	}
	break;
	case ACCUMULATE:{
		/*  		  GET,w    PUT,w    PUT_ACC,w   GET,w1     PUT,w1  PUT_ACC,w1
		 *		Aw      Sw      Sw         Aw          X          X       AM
		 *		AM       X       X         AM          X          X       AM
		 */
		if (OPEN == prev_worker){
			goto consistency_error;
		} else if (MULTIPLE_WORKER == prev_worker){
			if (SIPMPIConstants::PUT_ACCUMULATE == operation){
				new_mode = ACCUMULATE; new_worker = MULTIPLE_WORKER;
			} else {
				goto consistency_error;
			}
		} else { // Single worker
			switch(operation){
			case SIPMPIConstants::GET : case SIPMPIConstants::PUT : {
				if (prev_worker != worker)
					goto consistency_error;
				new_worker = worker;
				new_mode = SINGLE_WORKER;
			}
			break;
			case SIPMPIConstants::PUT_ACCUMULATE :	{
				new_mode = ACCUMULATE;
				new_worker = (worker == prev_worker ? worker : MULTIPLE_WORKER);
			}
			break;
			default : goto consistency_error;
			}
		}
	}
	break;
	case SINGLE_WORKER:{
		/*  		  GET,w    PUT,w    PUT_ACC,w   GET,w1     PUT,w1  PUT_ACC,w1
		 *		Sw      Sw      Sw         Sw          X          X       X
		 */
		if (worker == prev_worker){
			new_mode = SINGLE_WORKER; new_worker = worker;
		} else {
			goto consistency_error;
		}
	}
	break;
	default:
		goto consistency_error;
	}

	consistency_status_.first = new_mode;
	consistency_status_.second = new_worker;
	return true;

consistency_error:
	SIP_LOG(std::cout << "Inconsistent block at server ")
	consistency_status_.first = INVALID_MODE;
	consistency_status_.second = INVALID_WORKER;

	return false;

}


} /* namespace sip */
