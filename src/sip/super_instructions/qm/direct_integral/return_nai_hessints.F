C-----------------------------------------------------------------
!> special  return_nai_hessints wru
!> 
!> Return the one-particle part of the gradient by taking the 
!> diect prodcut of the one paticle density matrix and the 
!> derivative integrals. The space for the deriavtive integrals is a
!> temp array in SIAL (customarily) and the density matix 
!> can be of anytype. The gradient are returned in the static arrray.
!>
!>  do mu
!>  do nu
!>     excecute return_nai_hessints I(mu,nu) D(mu,nu) Hess(9*natoms*natoms)
!>  enddo nu
!>  enddo mu
!> 
!>  Ajith Perera, 09/2015.
C-----------------------------------------------------------------

      subroutine return_nai_hessints(
     c array_slot_0, rank_0, index_values_0, size_0, extents_0, data_0,
     c array_slot_1, rank_1, index_values_1, size_1, extents_1, data_1,
     c array_slot_2, rank_2, index_values_2, size_2, extents_2, data_2,
     c  ierr) BIND(C)

      use, intrinsic :: ISO_C_BINDING
      implicit none
    
c---------------------------------------------------------------------------
c Interface added but should be included instead 

      include 'sip_interface.f' 
      include 'imemory.h' 
c---------------------------------------------------------------------------

      integer(C_INT), intent(in)::array_slot_0
      integer(C_INT), intent(in)::rank_0
      integer(C_INT), intent(in)::index_values_0(1:rank_0)
      integer(C_INT), intent(in)::size_0
      integer(C_INT), intent(in)::extents_0(1:rank_0)
      real(C_DOUBLE), intent(out)::data_0(1:size_0)

      integer(C_INT), intent(in)::array_slot_1
      integer(C_INT), intent(in)::rank_1
      integer(C_INT), intent(in)::index_values_1(1:rank_1)
      integer(C_INT), intent(in)::size_1
      integer(C_INT), intent(in)::extents_1(1:rank_1)
      real(C_DOUBLE), intent(in)::data_1(1:size_1)

      integer(C_INT), intent(in)::array_slot_2
      integer(C_INT), intent(in)::rank_2
      integer(C_INT), intent(in)::index_values_2(1:rank_2)
      integer(C_INT), intent(in)::size_2
      integer(C_INT), intent(in)::extents_2(1:rank_2)
      real(C_DOUBLE), intent(out)::data_2(1:size_2)

      integer(C_INT), intent(out)::ierr

      integer(C_INT) ncenters  
      integer(C_INT) npcoeff  

      real(C_DOUBLE), pointer :: scr(:)
      integer, pointer :: iscr(:)
      TYPE(C_PTR) :: cscr
      TYPE(C_PTR) :: ciscr

      TYPE(C_PTR) :: cptr_zsum1
      real(C_DOUBLE), pointer :: fptr_zsum1(:)

c Nuclear coordinates 
c --------------------------------------------------------------------------- 
      TYPE(C_PTR) :: pDimCoords
      TYPE(C_PTR) :: pcoords
      integer, pointer :: sDimCoords(:)
      real(C_DOUBLE), pointer :: coords(:)

c Nuclear coordinates 
c --------------------------------------------------------------------------- 
      TYPE(C_PTR) :: pDimTCoords
      TYPE(C_PTR) :: pTcoords
      integer, pointer :: sDimTCoords(:)
      real(C_DOUBLE), pointer :: Tcoords(:)
c --------------------------------------------------------------------------- 
c aosegments 
c     integer(C_INT) n_ao_segs(1), aosegs(6)    
      TYPE(C_PTR) :: n_ao_segs, aosegs
      integer, pointer :: pn_ao_segs(:), paosegs(:)

      integer(C_INT) norb, one, two 
      integer(C_INT) offset_01, offset_02
      integer(C_INT) offset_11, offset_12 
      integer(C_INT) nscr, niscr   
      integer i, j
C
      ierr = 0
c-------------------------------------------------------------------------
c Get the data needed to do the computation.  
c--------------------------------------------------------------------------

c Nuclear coordinates 
      call predefined_scalar_array("coords"//C_NULL_CHAR,
     *                                  two, pDimCoords, pcoords)
      call c_f_pointer(pDimCoords, sDimCoords,[2]) 
      call c_f_pointer(pcoords, coords, sDimCoords) 

c Nuclear Tcoordinates 
c
      call predefined_scalar_array("tcoords"//C_NULL_CHAR,
     *                                  two, pDimTCoords, pTcoords)
      call c_f_pointer(pDimTCoords, sDimTCoords,[2]) 
      call c_f_pointer(pTcoords, Tcoords, sDimTCoords) 

c Number of nuclear centers 
c
      ncenters = int_constant("ncenters"//C_NULL_CHAR) 

c Number of coefficints c
c
      npcoeff = int_constant("npcoeffs"//C_NULL_CHAR) 
c
c Get the ao segment ranges  
c
      call predefined_int_array("ao_seg_ranges"//C_NULL_CHAR, one, 
     *                           n_ao_segs, aosegs)  
      call c_f_pointer(n_ao_segs,pn_ao_segs,[1]) 
      call c_f_pointer(aosegs,paosegs,pn_ao_segs) 

c   Set scratch space 

      nscr  = zmax 
      niscr = imax
     
      call scratch_array(nscr, cscr) 
      call c_f_pointer(cscr, scr, [nscr]) 

      call integer_scratch_array(niscr, ciscr) 
      call c_f_pointer(ciscr, iscr, [niscr])

c---------------------------------------------------------------------------
c   Compute data block of integrals.
c---------------------------------------------------------------------------
c Find the offset index ranges 
c
      offset_01 = 0 
      offset_02 = 0 
      offset_11 = 0 
      offset_12 = 0 

      if (index_values_0(1) .gt. 1) offset_01 
     &                              = paosegs(index_values_0(1)-1) 
      if (index_values_0(2) .gt. 1) offset_02 
     &                              = paosegs(index_values_0(2)-1) 

      if (index_values_1(1) .gt. 1) offset_11 
     &                              = paosegs(index_values_1(1)-1) 
      if (index_values_1(2) .gt. 1) offset_12 
     &                              = paosegs(index_values_1(2)-1) 


C#ifdef _DEBUG_LVL0
      write(6,"(a)") " At the entry to return_nai_hessints.F"
      Write(6,"(a,I4)") " ncenters: ", ncenters 
      Write(6,*)
      Write(6,"(a)") " The atom coordinates" 
      Write(6,"(3F12.6)") (coords(i),i=1,3*sDimCoords(2))
      write(*,*)
      Write(6,"(a)") " The atom coordinates of shells" 
      Write(6,"(3F12.6)") (Tcoords(i),i=1,sDimTCoords(1)*
     *                                     sDimTCoords(2))
      Write(*,*)
      Write(*,"(a)") " The extents of arrays passed in from SIAL"
      Write(*,"(4I4)")
     *                        extents_0(1),extents_0(2),
     *                        extents_1(1),extents_1(2)
      write(6,"(3(1x,F12.6))")(data_2(i),i=1,3*ncenters)
C#endif 

      call compute_return_nai_hessints(
     &                                data_0, data_1, data_2,
     &
     &                                1+offset_01, 
     &                                extents_0(1)+offset_01,
     &                                1+offset_02, 
     &                                extents_0(2)+offset_02, 
     &
     &                                1+offset_11, 
     &                                extents_1(1)+offset_11, 
     &                                1+offset_12, 
     &                                extents_1(2)+offset_12, 
     &  
     &                                ncenters, coords, tcoords, 
     &  
     &                                scr,iscr)
c
c  Remove scratch space  
c
      call delete_scratch_array(cscr)
      call delete_integer_scratch_array(ciscr)

      return
      end
