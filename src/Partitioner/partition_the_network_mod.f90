
!##################################################################################################
! Purpose: This module partitions the network and creates the input file for each process/rank.
!          To partition the network, we are using METIS graph partitioner. At the time of
!          developing this code, we have two versions of METIS: V4.0 and V5.X. We develop the code
!          such that both options are available. The main reason for having both options, and not
!          not just having the latest version, is that, based on our experience, the older version
!          handles the partitioning more efficiently.
!          The other option is using ParMetis, which is the parallel version of the METIS. We do
!          not believe that ParMETIS is needed. Metis would be efficient enough.
!
! Developed by: Babak Poursartip
! Supervised by: Clint Dawson
!
! The Institute for Computational Engineering and Sciences (ICES)
! The University of Texas at Austin
!
! ================================ V E R S I O N ==================================================
! V0.00: 04/15/2018 - File initiated.
! V2.00: 04/17/2018 - Debugged successfully.
! V3.00: 06/25/2018 - Modifying the partitioner module to partition a network.
!
! File version $Id $
!
! Last update: 06/25/2018
!
! ================================ S U B R O U T I N E ============================================
! Network_Partitioner_Sub: Creates the input files for various processes.
!
! ================================ F U N C T I O N ================================================
!
! ================================ L O C A L   V A R I A B L E S ==================================
! (Refer to the main code to see the list of imported variables)
!  . . . . . . . . . . . . . . . . Variables . . . . . . . . . . . . . . . . . . . . . . . . . . .
!
!##################################################################################################

module Network_Partitioner_mod

! Libraries =======================================================================================

! User defined modules ============================================================================
use Parameters_mod
use messages_and_errors_mod
use Discretization_mod, only: DiscretizedNetwork_tp
use Input_mod,          only: Input_Data_tp
use Model_mod,          only: Geometry_tp

implicit none

! This type contains all the variables required to partition a graph using METIS version 5.1.0.
! We define the required variables as pointers, because it is described in the METIS manual. Using
! non-pointer variables is also possible, but, to have more control over the METIS options, we
! prefer pointers.
type METIS_var5_tp
  ! The number of vertices in the graph= NoNodes in the network
  integer(kind=Lng), pointer :: nvtxs => null

  ! The number of balancing constraints. It should be at least 1
  integer(kind=Lng), pointer :: ncon => null

  ! The adjacency structure of the graph as described in Section 5.5. The size of array is nvtxs+1
  integer(kind=Lng), pointer, dimension(:) :: xadj => null

  ! The adjacency structure of the graph as described in Section 5.5.
  ! The size of this array is "2*(number of edges(=no or reaches))"
  integer(kind=Lng), pointer, dimension(:) :: adjncy => null

  ! The weights of the vertices as described in Section 5.5.
  ! This array stays null in our case. The size of this array is nvtxs * ncon
  integer(kind=Lng), pointer, dimension(:) :: vwgt => null

  ! The size of the vertices for computing the total communication volume as described in
  ! Section 5.7. The size of this array is nvtxs
  integer(kind=Lng), pointer, dimension(:) :: vsize => null

  ! The weights of the edges as described in Section 5.5. The size of this array is 2 * m,
  ! where m is the total number of edges.
  integer(kind=Lng), pointer, dimension(:) :: adjwgt => null

  ! The number of parts to partition the graph
  integer(kind=Lng), pointer,              :: nparts => null

  ! specifies the desired weight for each partition and constraint.
  ! The size of the array nparts×ncon.
  integer(kind=Lng), pointer, dimension(:) :: tpwgts  => null

  ! This is an array of size ncon that specifies the allowed load imbalance tolerance
  ! for each constraint.
  integer(kind=Lng), pointer, dimension(:) :: ubvec => null

  ! see page 21.
  integer(kind=Lng), pointer, dimension(:) :: options => null

  ! Upon successful completion, this variable stores the edge-cut or the total communication volume
  ! of the partitioning solution. The value returned depends on the partitioning’s objective
  ! function.
  integer(kind=Lng), pointer               :: objval => null

  ! This is a vector of "size nvtxs" that upon successful completion stores the partition
  ! vector of the graph. The numbering of this vector starts from either 0 or 1, depending on
  ! the value of options[METIS OPTION NUMBERING].
  integer(kind=Lng), pointer, dimension(:) :: part => null
end type METIS_var5_tp

! This type contains all the variables required to partition a graph using METIS version 4.0.0
! We define the required variables as pointers, because it is described in the METIS manual. Using
! non-pointer variables is also possible, but, to have more control over the METIS options, we
! prefer pointers.
type METIS_var4_tp

  ! The number of vertices in the graph= NoNodes in the network
  integer(kind=Lng), pointer :: n => null

  ! The adjacency structure of the graph as described in Section 5.1. The size of array is n+1
  integer(kind=Lng), pointer, dimension(:) :: xadj => null

  ! The adjacency structure of the graph as described in Section 5.1.
  ! The size of this array is "2*(number of edges(=no or reaches))"
  integer(kind=Lng), pointer, dimension(:) :: adjncy => null

  ! The weights of the vertices as described in Section 5.1.
  ! This array stays null in our case. The size of this array is nvtxs * ncon
  integer(kind=Lng), pointer, dimension(:) :: vwgt => null

  ! The weights of the edges as described in Section 5.5. The size of this array is 2 * m,
  ! where m is the total number of edges.
  integer(kind=Lng), pointer, dimension(:) :: adjwgt => null

  ! Used the indicate if the graph is weighted. (see page 22 of manual of version 4).
  ! wgtflags can take the following values:
  ! 1 weights on the edges only (vwgts = NULL)
  integer(kind=Lng), pointer               :: wgtflag => null

  ! Indicated the C or Fortran style of numbering: 0: C or 1: fortran
  integer(kind=Lng), pointer               :: numflag => null

  ! The number of parts to partition the graph
  integer(kind=Lng), pointer,              :: nparts => null

  ! see page 22. Use options[0]=0.
  integer(kind=Lng), pointer, dimension(:) :: options => null

  ! The number of edges that are cut by the partition. In our case, this indicates the total number
  ! of communication between the ranks.
  integer(kind=Lng), pointer               :: edgecut => null

  ! This is a vector of "size nvtxs" that upon successful completion stores the partition
  ! vector of the graph. The numbering of this vector starts from either 0 or 1, depending on
  ! the value of options[METIS OPTION NUMBERING].
  integer(kind=Lng), pointer, dimension(:) :: part => null


end type METIS_var4_tp


type partitioner_tp

  type(METIS_var4_tp) :: METIS4
  type(METIS_var5_tp) :: METIS5
  contains
    generic :: Partition => Network_Partitioner_Sub

end type partitioner_tp


contains

!##################################################################################################
! Purpose: This subroutine creates the input file for each partition/process. To this aim, we are
! using METIS graph partitioner. We treat nodes (the upstream and downstream point of each reach)
! as vertices, and reaches as edges. Since the length of each reach is different, consequently, the
! number of cells are different in each reach, to have a balanced load distribution, we use a
! "weighted" graph partitioner subroutine/ function in METIS, as follows:
!
! 1- If we use METIS v4.0, to partition a graph, we have two options (see page 8 of the METIS
! manual v4.0): one method is "pmetis", and the other one is "kmetis". According the instruction in
! the manual, kmetis is more efficient to partition a model to more than 8 partitions. Therefore,
! we only use this option. The corresponding subroutine/function is METIS_PartGraphKway, discussed
! on page 22 of the manual.
!
! 2- If we use METIS V5.1.0, the only option for graph partitioning is METIS_PartGraphKway,
! described on page 26.
!
! The arguments of the two subroutines are different. We design this code the latest version.
!
! Developed by: Babak Poursartip
!
! The Institute for Computational Engineering and Sciences (ICES)
! The University of Texas at Austin
!
! ================================ V E R S I O N ==================================================
! V0.00: 04/15/2018 - Subroutine initiated.
! V0.01: 04/16/2018 - Initiated: Compiled without error for the first time.
! V1.00: 04/20/2018 - Make it compatible with the main code
! V2.00: 06/21/2018 - Modifying the subroutine to partition a network, use METIS graph partitioner
!
! File version $Id $
!
! Last update: 06/21/2018
!
! ================================ L O C A L   V A R I A B L E S ==================================
! (Refer to the main code to see the list of imported variables)
!  . . . . . . . . . . . . . . . . Variables . . . . . . . . . . . . . . . . . . . . . . . . . . .
!
!##################################################################################################

subroutine Network_Partitioner_Sub(this, Geometry, Discretization, ModelInfo)

! Libraries =======================================================================================

! User defined modules ============================================================================

implicit none

! Global variables ================================================================================

! - types -----------------------------------------------------------------------------------------
type(Input_Data_tp), intent(In) :: ModelInfo ! Holds info. (name, dir, output dir) of the model
type(Geometry_tp),   intent(In) :: Geometry  ! Holds the geometry of the network
type(DiscretizedNetwork_tp),      intent(In) :: Discretization ! Holds the discretized network

class(partitioner_tp) :: this ! defining the variables to partition a network using METIS

! Local variables =================================================================================
! - integer variables -----------------------------------------------------------------------------
integer(kind=Smll) :: UnFile      ! Holds Unit of a file for error message
integer(kind=Smll) :: IO_File        ! For IOSTAT: Input Output Status in OPEN command
integer(kind=Smll) :: IO_write       ! Used for IOSTAT: Input/Output Status in the write command

integer(kind=Shrt) :: i_partition ! Loop index for the number of processes/ranks
integer(kind=Shrt) :: i           ! Loop index
integer(kind=Shrt) :: remainder   !

integer(kind=Lng) :: counter      ! Counter for cells
integer(kind=Lng) :: i_cells      ! Loop index for counting number of cells

! - integer Arrays --------------------------------------------------------------------------------
integer(kind=Lng), dimension (Geometry%size)  :: chunk       ! share of the domain for each rank

! - character variables ---------------------------------------------------------------------------
Character(kind = 1, len = 20) :: IndexRank ! Rank no in the Char. fmt to add to the input file Name

! code ============================================================================================
write(*,        fmt="(A)") " subroutine < Network_Partitioner_Sub >: "
write(FileInfo, fmt="(A)") " subroutine < Network_Partitioner_Sub >: "

! Computing the chunk of each process
write(*,        fmt="(A)") " calculating the average number of cells on each rank ... "
write(FileInfo, fmt="(A)") " calculating the average number of cells on each rank ... "

remainder = mod(Discretization%NCells, Geometry%Base_Geometry%size)
chunk(:)  = (Discretization%NCells - remainder)/Geometry%Base_Geometry%size
  do i = 1_Shrt, remainder
    chunk(i) = chunk(i) + 1
  end do

! - Prepare for partitioning ----------------------------------------------------------------------
write(*,        fmt="(A)") " -Preparing data for METIS ... "
write(FileInfo, fmt="(A)") " -Preparing data for METIS ... "





! - partitioning using METIS ----------------------------------------------------------------------
write(*,        fmt="(A)") " -Graph partitioning using METIS_PartGraphKway... "
write(FileInfo, fmt="(A)") " -Graph partitioning using METIS_PartGraphKway ... "

call METIS_PartGraphKway(   & !
                            & ! nvtxs: The number of vertices in the graph
                            & ! ncon:  The number of balancing constraints. It should be at least 1
                            & ! xadj:  The adjacency structure of the graph as described in Section 5.5
                            & ! adjncy: The adjacency structure of the graph as described in Section 5.5
                            & ! vwgt:   The weights of the vertices as described in Section 5.5
                            & ! vsize:  The size of the vertices for computing the total communication volume as described in Section 5.7
                            & ! adjwgt: The weights of the edges as described in Section 5.5
                            & ! nparts: The number of parts to partition the graph
                            & ! tpwgts:
                            & ! ubvec
                            & ! options
                            & ! objval
                            & ! part
)




! - printing out the partitioned data -------------------------------------------------------------

counter = 0_Lng

  On_Partitions: do i_partition = 1, Geometry%size
    write(*,*)
    write(*,        fmt="(A,I10)") " Partitioning for process no.: ", i_partition-1_Shrt
    write(FileInfo, fmt="(A,I10)") " Partitioning for process no.: ", i_partition-1_Shrt

    ! Opening the output files.
    write(*,       *) " Creating input files ..."
    write(FileInfo,*) " Creating input files ..."

    ! Directories for the input files <modify>
    ! open file for this partition
    write(IndexRank, *) i_partition - 1_Shrt ! Converts Rank to Character format for the file Name

    UnFile = FilePartition
    open(unit=UnFile, &
         file=trim(ModelInfo%ModelName)//'_s'//&
              trim(adjustL(Geometry%IndexSize))//'_p'//trim(adjustL(IndexRank))//'.par', &
         Err=1001, iostat=IO_File, access='sequential', action='write', asynchronous='no', &
         blank='NULL', blocksize=0, defaultfile=trim(ModelInfo%InputDir), dispose='keep', &
         form='formatted', position='asis', status='replace')

    ! Writing the total number of cells in each partition
    UnFile = FilePartition
    write(unit=UnFile, fmt="(I23)", advance='yes', asynchronous='no', &
          iostat=IO_write, err=1006) chunk(i_partition)

    UnFile = FilePartition

      do i_cells = 1_Lng, chunk(i_partition)

        counter = counter + 1_Lng
        write(unit=UnFile, fmt="(8F35.20)", &
              advance='yes', asynchronous='no', iostat=IO_write, err=1006) &
              Discretization%LengthCell (counter,1),                       &
              Discretization%LengthCell (counter,2),                       &
              Discretization%CellSlope  (counter),                         &
              Discretization%ZCell      (counter),                         &
              Discretization%ManningCell(counter),                         &
              Discretization%WidthCell  (counter),                         &
              Discretization%XCell     (counter),                         &
              Discretization%InterfaceSlope (counter)

              !Discretization%ZFull      (counter*2_Lng-1_Lng),             &
              !Discretization%ZFull      (counter*2_Lng),                   &
              !Discretization%XFull     (counter*2_Lng-1_Lng),             &
              !Discretization%XFull     (counter*2_Lng      )
      end do
    write(unit=UnFile, fmt="(F35.20)", &
          advance='yes', asynchronous='no', iostat=IO_write, err=1006) &
          Discretization%InterfaceSlope(counter+1_Lng)

    ! - Closing the input file for this partition -------------------------------------------------
    write(*,        *) " Closing the input file ... "
    write(FileInfo, *) " Closing the input file ... "

    UnFile =  FilePartition
    close(unit=UnFile, status="keep", err=1002, iostat=IO_File)

  end do On_Partitions

  if (counter/= Discretization%NCells) then
    write(*,       *) "Fatal error! Mismatch in the number of cells. &
                       Check the partitioner subroutine.", counter, Discretization%NCells
    write(FileInfo,*) "Fatal error! Mismatch in the number of cells. &
                       Check the partitioner subroutine.", counter, Discretization%NCells
    write(*, Fmt_FL); write(FileInfo, Fmt_FL);
    write(*, Fmt_end); read(*,*); stop;
  end if




















write(*,       *) " Partitioning conducted successfully."
write(FileInfo,*) " Partitioning conducted successfully."

write(*,       *) " end subroutine < Network_Partitioner_Sub >"
write(FileInfo,*) " end subroutine < Network_Partitioner_Sub >"
return

! Errors ==========================================================================================
! Opening statement Errors
1001 call errorMessage(UnFile, IO_File)

! Close statement Errors
1002 call error_in_closing_a_file(UnFile, IO_File)

! write statement errors
1006 call error_in_writing(UnFile, IO_write)

end subroutine Network_Partitioner_Sub

end module Network_Partitioner_mod
