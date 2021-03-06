C Copyright (c) 2003-2010 University of Florida  
C
C This program is free software; you can redistribute it and/or modify
C it under the terms of the GNU General Public License as published by
C the Free Software Foundation; either version 2 of the License, or
C (at your option) any later version.

C This program is distributed in the hope that it will be useful,
C but WITHOUT ANY WARRANTY; without even the implied warranty of
C MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
C GNU General Public License for more details.

C The GNU General Public License is included in this distribution
C in the file COPYRIGHT.
      subroutine energy_denominator(
     * array_0, rank_0, index_values_0, size_0, extents_0, data_0,
     * array_1, rank_1, index_values_1, size_1, extents_1, data_1,
     * array_2, rank_2, index_values_2, size_2, extents_2, data_2,
     * array_3, rank_3, index_values_3, size_3, extents_3, data_3,
     * ierr) BIND(C)
      use, intrinsic :: ISO_C_BINDING
      implicit none

c--------------------------------------------------------------------------
!> special energy_denominator urrr 
!> computes the denominator of an  array with possible  dimensions 
!> of 2, 4 or 6. The spin of the two input arrays can be the 
!> same (alpha or beta) or different (alpha,beta). The last argument 
!> is the indicator of the spin-type. 
c--------------------------------------------------------------------------
      include 'sip_interface.f'

! output array --> array_0
      integer(C_INT), intent(in)::array_0
      integer(C_INT), intent(in)::rank_0
      integer(C_INT), intent(in)::index_values_0(1:rank_0)
      integer(C_INT), intent(in)::size_0
      integer(C_INT), intent(in)::extents_0(1:rank_0)
      real(C_DOUBLE), intent(out)::data_0(1:size_0)

      integer(C_INT), intent(in)::array_1
! scalar array --> array_1
      integer(C_INT), intent(in)::rank_1
      integer(C_INT), intent(in)::index_values_1(1:rank_1)
      integer(C_INT), intent(in)::size_1
      integer(C_INT), intent(in)::extents_1(1:rank_1)
      real(C_DOUBLE), intent(in)::data_1(1:size_1)

! scalar array --> array_2
      integer(C_INT), intent(in)::array_2
      integer(C_INT), intent(in)::rank_2
      integer(C_INT), intent(in)::index_values_2(1:rank_2)
      integer(C_INT), intent(in)::size_2
      integer(C_INT), intent(in)::extents_2(1:rank_2)
      real(C_DOUBLE), intent(in)::data_2(1:size_2)

! scalar array --> array_2
      integer(C_INT), intent(in)::array_3
      integer(C_INT), intent(in)::rank_3
      integer(C_INT), intent(in)::index_values_3(1:rank_2)
      integer(C_INT), intent(in)::size_3
      integer(C_INT), intent(in)::extents_3(1:rank_2)
      real(C_DOUBLE), intent(in)::data_3(1:size_3)

      integer(C_INT), intent(out)::ierr
c mosegments 

      TYPE(C_PTR) :: cptr_n_moa_segs, cptr_moa_segs
      integer, pointer :: fptr_moa_segs(:), fptr_n_moa_segs(:)

      TYPE(C_PTR) :: cptr_n_mob_segs, cptr_mob_segs
      integer, pointer :: fptr_mob_segs(:), fptr_n_mob_segs(:)

      integer(C_INT) offset_1a, offset_2a, offset_3a, offset_4a
      integer(C_INT) offset_1b, offset_2b, offset_3b, offset_4b

      integer(C_INT) i, i1, i2, i3, i4, one, iflag

      ierr = 0

      Iflag = INT(data_3(1))
C
C If the rank of the incomming array is four (for example, T2(II,AB,
C T2(Ij,AB), T(ij,ab)) 
C

      if (rank_0 .eq. 4) then 
   
         If (Iflag .EQ. 1) then

C The incoming arrays are AAAA type et the mo segment ranges

           call predefined_int_array("moa_seg_ranges"//C_NULL_CHAR, 
     &                                one,cptr_n_moa_segs, 
     &                                cptr_moa_segs)
           call c_f_pointer(cptr_n_moa_segs,fptr_n_moa_segs,[1])
           call c_f_pointer(cptr_moa_segs,fptr_moa_segs,
     &                      fptr_n_moa_segs)

           offset_1a = 0
           offset_2a = 0
           offset_3a = 0
           offset_4a = 0
           if (index_values_0(1).gt.1) then
              do i = 1, index_values_0(1) - 1
                 offset_1a = offset_1a + fptr_moa_segs(i)
              enddo
           endif
           if (index_values_0(2).gt.1) then
              do i = 1, index_values_0(2) - 1
                 offset_2a = offset_2a + fptr_moa_segs(i)
              enddo
          endif
          if (index_values_0(3).gt.1) then
             do i = 1, index_values_0(3) - 1
                offset_3a = offset_3a + fptr_moa_segs(i)
             enddo
          endif
          if (index_values_0(4).gt.1) then
             do i = 1, index_values_0(4) - 1
                offset_4a = offset_4a + fptr_moa_segs(i)
             enddo
          endif

          if (rank_1 .eq. 2) then
             call do_aaaa_den4(1, extents_0(1),offset_1a,
     *                         1, extents_0(2),offset_2a,
     *                         1, extents_0(3),offset_3a,
     *                         1, extents_0(4),offset_4a,
     *                         data_0,
     *
     *                         1, extents_1(1), 1, extents_1(2),
     *
     *                         data_1)
          endif

          if (rank_1 .eq. 1) then
             call do_aaaa_den4_1D(1, extents_0(1),offset_1a,
     *                            1, extents_0(2),offset_2a,
     *                            1, extents_0(3),offset_3a,
     *                            1, extents_0(4),offset_4a,
     *                            data_0,
     *
     *                            1, extents_1(1),
     *                            data_1)
          endif


         Elseif (Iflag .EQ. 2) then

C The incoming arrays are BBBB type et the mo segment ranges

           call predefined_int_array("mob_seg_ranges"//C_NULL_CHAR, 
     &                                one,cptr_n_mob_segs, 
     &                                cptr_mob_segs)
           call c_f_pointer(cptr_n_mob_segs,fptr_n_mob_segs,[1])
           call c_f_pointer(cptr_mob_segs,fptr_mob_segs,
     &                      fptr_n_mob_segs)

           offset_1b = 0
           offset_2b = 0
           offset_3b = 0
           offset_4b = 0
           if (index_values_0(1).gt.1) then
              do i = 1, index_values_0(1) - 1
                 offset_1b = offset_1b + fptr_mob_segs(i)
              enddo
           endif
           if (index_values_0(2).gt.1) then
              do i = 1, index_values_0(2) - 1
                 offset_2b = offset_2b + fptr_mob_segs(i)
              enddo
          endif
          if (index_values_0(3).gt.1) then
             do i = 1, index_values_0(3) - 1
                offset_3b = offset_3b + fptr_mob_segs(i)
             enddo
          endif
          if (index_values_0(4).gt.1) then
             do i = 1, index_values_0(4) - 1
                offset_4b = offset_4b + fptr_mob_segs(i)
             enddo
          endif

          if (rank_1 .eq. 2) then
             call do_bbbb_den4(1, extents_0(1),offset_1b,    
     *                         1, extents_0(2),offset_2b,
     *                         1, extents_0(3),offset_3b,
     *                         1, extents_0(4),offset_4b,
     *                         data_0,
     *
     *                         1, extents_1(1), 1, extents_1(2),
     *
     *                         data_1)
          endif

          if (rank_1 .eq. 1) then
             call do_bbbb_den4_1D(1, extents_0(1),offset_1b,
     *                            1, extents_0(2),offset_2b,
     *                            1, extents_0(3),offset_3b,
     *                            1, extents_0(4),offset_4b,
     *                            data_0,
     *
     *                            1, extents_1(1),
     *
     *                            data_1)
          endif


         Elseif (Iflag .EQ. 3) then

C The incoming arrays are ABAB type and get the mo segment ranges.

           call predefined_int_array("moa_seg_ranges"//C_NULL_CHAR,
     &                                one,cptr_n_moa_segs,
     &                                cptr_moa_segs)
           call c_f_pointer(cptr_n_moa_segs,fptr_n_moa_segs,[1])
           call c_f_pointer(cptr_moa_segs,fptr_moa_segs,
     &                      fptr_n_moa_segs)

           call predefined_int_array("mob_seg_ranges"//C_NULL_CHAR, 
     &                                one,cptr_n_mob_segs, 
     &                                cptr_mob_segs)
           call c_f_pointer(cptr_n_mob_segs,fptr_n_mob_segs,[1])
           call c_f_pointer(cptr_mob_segs,fptr_mob_segs,
     &                      fptr_n_mob_segs)
           offset_1a = 0
           offset_2a = 0
           offset_1b = 0
           offset_2b = 0
           if (index_values_0(1).gt.1) then
              do i = 1, index_values_0(1) - 1
                 offset_1a = offset_1a + fptr_moa_segs(i)
              enddo
           endif
           if (index_values_0(2).gt.1) then
              do i = 1, index_values_0(2) - 1
                 offset_2a = offset_2a + fptr_moa_segs(i)
              enddo
          endif
          if (index_values_0(3).gt.1) then
             do i = 1, index_values_0(3) - 1
                offset_1b = offset_1b + fptr_mob_segs(i)
             enddo
          endif
          if (index_values_0(4).gt.1) then
             do i = 1, index_values_0(4) - 1
                offset_2b = offset_2b + fptr_mob_segs(i)
             enddo
          endif

          if (rank_1 .eq. 2) then
             call do_abab_den4(1, extents_0(1),offset_1a,
     *                         1, extents_0(2),offset_2a,
     *                         1, extents_0(3),offset_1b,
     *                         1, extents_0(4),offset_2b,
     *                         data_0,
     *
     *                         1, extents_1(1), 1, extents_1(2),
     *                         1, extents_2(1), 1, extents_2(2),
     *
     *                         data_1, data_2)
          endif

          if (rank_1 .eq. 1) then
             call do_abab_den4_1D(1, extents_0(1),offset_1a,
     *                            1, extents_0(2),offset_2a,
     *                            1, extents_0(3),offset_1b,
     *                            1, extents_0(4),offset_2b,
     *                            data_0,
     *
     *                            1, extents_1(1),
     *                            1, extents_2(1),
     *
     *                            data_1, data_2)
          endif
C
        Endif
C
C If the rank of the incomming array is two (for example, T1(I,B),
C T1(i,a))

      ELseif (rank_0 .eq. 2) then

         If (Iflag .EQ. 1) then

C The incoming arrays are AA type. get the mo segment ranges

           call predefined_int_array("moa_seg_ranges"//C_NULL_CHAR,
     &                                one,cptr_n_moa_segs,
     &                                cptr_moa_segs)
           call c_f_pointer(cptr_n_moa_segs,fptr_n_moa_segs,[1])
           call c_f_pointer(cptr_moa_segs,fptr_moa_segs,
     &                      fptr_n_moa_segs)

           offset_1a = 0
           offset_2a = 0
           offset_3a = 0
           offset_4a = 0
           if (index_values_0(1).gt.1) then
              do i = 1, index_values_0(1) - 1
                 offset_1a = offset_1a + fptr_moa_segs(i)
              enddo
           endif
           if (index_values_0(2).gt.1) then
              do i = 1, index_values_0(2) - 1
                 offset_2a = offset_2a + fptr_moa_segs(i)
              enddo
          endif

          if (rank_1 .eq. 2) then
             call do_aa_den2(1, extents_0(1),offset_1a,
     *                       1, extents_0(2),offset_2a,
     *                       data_0,
     *
     *                       1, extents_1(1), 1, extents_1(2),
     *
     *                       data_1)
          endif

          if (rank_1 .eq. 1) then
             call do_aa_den2_1D(1, extents_0(1),offset_1a,
     *                          1, extents_0(2),offset_2a,
     *                          data_0,
     *
     *                          1, extents_1(1),
     *                          data_1)
           endif


         Elseif (Iflag .EQ. 2) then
  
C The incoming arrays are BB type and get the mo segment ranges

           call predefined_int_array("mob_seg_ranges"//C_NULL_CHAR,
     &                                one,cptr_n_mob_segs,
     &                                cptr_mob_segs)
           call c_f_pointer(cptr_n_mob_segs,fptr_n_mob_segs,[1])
           call c_f_pointer(cptr_mob_segs,fptr_mob_segs,
     &                      fptr_n_mob_segs)

           offset_1b = 0
           offset_2b = 0
           if (index_values_0(1).gt.1) then
              do i = 1, index_values_0(1) - 1
                 offset_1b = offset_1b + fptr_mob_segs(i)
              enddo
           endif
           if (index_values_0(2).gt.1) then
              do i = 1, index_values_0(2) - 1
                 offset_2b = offset_2b + fptr_mob_segs(i)
              enddo
          endif

          if (rank_1 .eq. 2) then
             call do_bb_den2(1, extents_0(1),offset_1b,
     *                       1, extents_0(2),offset_2b,
     *                       data_0,
     * 
     *                       1, extents_1(1), 1, extents_1(2),
     *
     *                       data_1)
          endif

          if (rank_1 .eq. 1) then
             call do_bb_den2_1D(1, extents_0(1),offset_1b,
     *                          1, extents_0(2),offset_2b,
     *                          data_0,
     *
     *                          1, extents_1(1),
     *
     *                          data_1)
           endif
        Endif 

      Endif 

      return
      end
C
C----------------------------------------------------------------------o
C

      subroutine do_aaaa_den4(a1, a2, off_1, b1, b2, off_2, 
     *                        c1, c2, off_3, d1, d2, off_4, 
     *                        array, 
     *
     *                        m1, m2, n1, n2, 
     *
     *                        fock)
      
      implicit none
      integer a, a1, a2, b, b1, b2, c, c1, c2, d, d1, d2, m1, m2, n1, n2
      integer r1, r2, s1, s2
      integer off_1, off_2, off_3, off_4 
      double precision array(a1:a2,b1:b2,c1:c2,d1:d2) 
      double precision fock(m1:m2,n1:n2) 
      double precision val, eps, epsa, epsb, epsc, epsd   

      val = 0.0 
      do d = d1, d2 
         epsd = fock(d+off_4,d+off_4) 
      do c = c1, c2 
         epsc = fock(c+off_3,c+off_3) 
      do b = b1, b2 
         epsb = fock(b+off_2,b+off_2) 
      do a = a1, a2 
         epsa = fock(a+off_1,a+off_1) 

         eps = epsb + epsd - epsa - epsc 

         array(a,b,c,d) = array(a,b,c,d)/eps  
      enddo 
      enddo 
      enddo 
      enddo 

      return
      end

      subroutine do_aaaa_den4_1d(a1, a2, off_1, b1, b2, off_2, 
     *                           c1, c2, off_3, d1, d2, off_4, 
     *                           array, 
     *
     *                           m1, m2, 
     *
     *                           fock)
      

      implicit none
      integer a, a1, a2, b, b1, b2, c, c1, c2, d, d1, d2, m1, m2, n1, n2
      integer off_1, off_2, off_3, off_4 
      double precision array(a1:a2,b1:b2,c1:c2,d1:d2) 
      double precision fock(m1:m2) 
      double precision val, eps, epsa, epsb, epsc, epsd   

      val = 0.0 
      do d = d1, d2 
         epsd = fock(d+off_4) 
      do c = c1, c2
         epsc = fock(c+off_3) 
      do b = b1, b2 
         epsb = fock(b+off_2) 
      do a = a1, a2 
         epsa = fock(a+off_1) 

         eps = epsb + epsd - epsa - epsc 

         array(a,b,c,d) = array(a,b,c,d)/eps  
      enddo 
      enddo 
      enddo 
      enddo

      return
      end

      subroutine do_bbbb_den4(a1, a2, off_1, b1, b2, off_2,
     *                        c1, c2, off_3, d1, d2, off_4,
     *                        array,
     *
     *                        m1, m2, n1, n2,
     *
     *                        fock)

      implicit none
      integer a, a1, a2, b, b1, b2, c, c1, c2, d, d1, d2, m1, m2, n1, n2
      integer r1, r2, s1, s2
      integer off_1, off_2, off_3, off_4
      double precision array(a1:a2,b1:b2,c1:c2,d1:d2)
      double precision fock(m1:m2,n1:n2)
      double precision val, eps, epsa, epsb, epsc, epsd

      val = 0.0
      do d = d1, d2
         epsd = fock(d+off_4,d+off_4)
      do c = c1, c2
         epsc = fock(c+off_3,c+off_3)
      do b = b1, b2
         epsb = fock(b+off_2,b+off_2)
      do a = a1, a2
         epsa = fock(a+off_1,a+off_1)

         eps = epsb + epsd - epsa - epsc

         array(a,b,c,d) = array(a,b,c,d)/eps
      enddo
      enddo
      enddo
      enddo

      return
      end

      subroutine do_bbbb_den4_1d(a1, a2, off_1, b1, b2, off_2,
     *                           c1, c2, off_3, d1, d2, off_4,
     *                           array,
     *
     *                           m1, m2,
     *
     *                           fock)
     

      implicit none
      integer a, a1, a2, b, b1, b2, c, c1, c2, d, d1, d2, m1, m2, n1, n2
      integer off_1, off_2, off_3, off_4
      double precision array(a1:a2,b1:b2,c1:c2,d1:d2)
      double precision fock(m1:m2)
      double precision val, eps, epsa, epsb, epsc, epsd

      val = 0.0
      do d = d1, d2
         epsd = fock(d+off_4)
      do c = c1, c2
         epsc = fock(c+off_3)
      do b = b1, b2
         epsb = fock(b+off_2)
      do a = a1, a2
         epsa = fock(a+off_1)

         eps = epsb + epsd - epsa - epsc

         array(a,b,c,d) = array(a,b,c,d)/eps
      enddo
      enddo
      enddo
      enddo

      return
      end

      subroutine do_abab_den4(a1, a2, off_1a, b1, b2, off_2a,
     *                        c1, c2, off_1b, d1, d2, 
     *                        off_2b, array,
     *
     *                        m1, m2, n1, n2,
     *                        r1, r2, s1, s2,
     *
     *                        focka, fockb)

      implicit none
      integer a, a1, a2, b, b1, b2, c, c1, c2, d, d1, d2, m1, m2, n1, n2
      integer r1, r2, s1, s2
      integer off_1a, off_2a, off_1b, off_2b
      double precision array(a1:a2,b1:b2,c1:c2,d1:d2)
      double precision focka(m1:m2,n1:n2)
      double precision fockb(r1:r2,s1:s2)
      double precision val, eps, epsa, epsb, epsc, epsd

      val = 0.0
      do d = d1, d2
         epsd = fockb(d+off_2b,d+off_2b)
      do c = c1, c2
         epsc = fockb(c+off_1b,c+off_1b)
      do b = b1, b2
         epsb = focka(b+off_2a,b+off_2a)
      do a = a1, a2
         epsa = focka(a+off_1a,a+off_1a)

         eps = epsb + epsd - epsa - epsc

         array(a,b,c,d) = array(a,b,c,d)/eps

      enddo
      enddo
      enddo
      enddo

      return
      end

      subroutine do_abab_den4_1D(a1, a2, off_1a, b1, b2, off_2a,
     *                           c1, c2, off_1b, d1, d2, off_2b,
     *                           array,
     *
     *                           m1, m2,
     *                           r1, r2,
     *
     *                           focka, fockb)

      implicit none
      integer a, a1, a2, b, b1, b2, c, c1, c2, d, d1, d2, m1, m2, n1, n2
      integer r1, r2
      integer off_1a, off_2a, off_1b, off_2b
      double precision array(a1:a2,b1:b2,c1:c2,d1:d2)
      double precision focka(m1:m2)
      double precision fockb(r1:r2)
      double precision val, eps, epsa, epsb, epsc, epsd

      val = 0.0
      do d = d1, d2
         epsd = fockb(d+off_2b)
      do c = c1, c2
         epsc = fockb(c+off_1b)
      do b = b1, b2
         epsb = focka(b+off_2a)
      do a = a1, a2
         epsa = focka(a+off_1a)

         eps = epsb + epsd - epsa - epsc

         array(a,b,c,d) = array(a,b,c,d)/eps

      enddo
      enddo
      enddo
      enddo

      return
      end

      subroutine do_aa_den2(a1, a2, off_1, b1, b2, off_2,
     *                      array,
     *
     *                      m1, m2, n1, n2,
     *
     *                      fock)

      implicit none
      integer a, a1, a2, b,  b1, b2, m1, m2, n1, n2
      integer off_1, off_2, off_3, off_4
      double precision array(a1:a2,b1:b2)
      double precision fock(m1:m2,n1:n2)
      double precision val, eps, epsa, epsb

      val = 0.0
      do b = b1, b2
         epsb = fock(b+off_2,b+off_2)
      do a = a1, a2
         epsa = fock(a+off_1,a+off_1)

         eps = epsb  - epsa 

         array(a,b) = array(a,b)/eps
      enddo
      enddo

      return
      end

      subroutine do_aa_den2_1D(a1, a2, off_1, b1, b2, off_2,
     *                         array,
     *
     *                         m1, m2, 
     *
     *                         fock)

      implicit none
      integer a, a1, a2, b, b1, b2
      integer m1, m2
      integer off_1, off_2
      double precision array(a1:a2,b1:b2)
      double precision fock(m1:m2)
      double precision val, epsa, epsb, eps

      val = 0.0
      do b = b1, b2
         epsb = fock(b+off_2)
      do a = a1, a2
         epsa = fock(a+off_1)

         eps = epsb - epsa 

         array(a,b) = array(a,b)/eps
      enddo
      enddo

      return
      end

      subroutine do_bb_den2(a1, a2, off_1, b1, b2, off_2,
     *                      array,
     *
     *                      m1, m2, n1, n2,
     *
     *                      fock)

      implicit none
      integer a, a1, a2, b,  b1, b2, m1, m2, n1, n2
      integer off_1, off_2
      double precision array(a1:a2,b1:b2)
      double precision fock(m1:m2,n1:n2)
      double precision val, eps, epsa, epsb

      val = 0.0
      do b = b1, b2
         epsb = fock(b+off_2,b+off_2)
      do a = a1, a2
         epsa = fock(a+off_1,a+off_1)

         eps = epsb  - epsa

         array(a,b) = array(a,b)/eps
      enddo
      enddo

      return
      end

      subroutine do_bb_den2_1D(a1, a2, off_1, b1, b2, off_2,
     *                         array,
     *
     *                         m1, m2,
     *
     *                         fock)

      implicit none
      integer a, a1, a2, b, b1, b2
      integer m1, m2
      integer off_1, off_2, off_3, off_4
      double precision array(a1:a2,b1:b2)
      double precision fock(m1:m2)
      double precision val, epsa, epsb, eps

      val = 0.0
      do b = b1, b2
         epsb = fock(b+off_2)
      do a = a1, a2
         epsa = fock(a+off_1)

         eps = epsb - epsa

         array(a,b) = array(a,b)/eps
      enddo
      enddo

      return
      end





