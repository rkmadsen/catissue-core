////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package mx.collections.errors
{

/**
 *  This error is thrown by a collection Cursor.
 *  Errors of this class are thrown by classes
 *  that implement the IViewCursor interface.
 */
public class CursorError extends Error
{
    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    // Constructor.
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param message A message providing information about the error cause.
     */
    public function CursorError(message:String)
    {
        super(message);
    }
}

}
