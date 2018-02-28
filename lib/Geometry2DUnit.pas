{ ****************************************************************************** }
{ * geometry 2D library writen by QQ 600585@qq.com                             * }
{ * https://github.com/PassByYou888/CoreCipher                                 * }
{ * https://github.com/PassByYou888/ZServer4D                                  * }
{ * https://github.com/PassByYou888/zExpression                                * }
{ * https://github.com/PassByYou888/zTranslate                                 * }
{ * https://github.com/PassByYou888/zSound                                     * }
{ ****************************************************************************** }

unit Geometry2DUnit;

interface

{$I zDefine.inc}


uses CoreClasses, Sysutils, Math, Types;

type
  TGeoFloat     = Single;
  TGeoInt       = Integer;
  T2DPoint      = array [0 .. 1] of TGeoFloat;
  P2DPoint      = ^T2DPoint;
  TVec2         = T2DPoint;
  TPoint2       = T2DPoint;
  TArray2DPoint = array of T2DPoint;
  PArray2DPoint = ^TArray2DPoint;
  T2DRect       = array [0 .. 1] of T2DPoint;
  P2DRect       = ^T2DRect;
  TRect2        = T2DRect;
  TRect2D       = T2DRect;

  {$IFDEF FPC}

  TPointf = packed record
    X: TGeoFloat;
    Y: TGeoFloat;
  end;

  PPointf = ^TPointf;

  TRectf = packed record
    case Integer of
      0:
        (Left, Top, Right, Bottom: TGeoFloat);
      1:
        (TopLeft, BottomRight: TPointf);
  end;

  PRectf = ^TRectf;

function Pointf(X, Y: TGeoFloat): TPointf;
function Rectf(Left, Top, Right, Bottom: TGeoFloat): TRectf;
{$ENDIF}


const
  XPoint: T2DPoint    = (1, 0);
  YPoint: T2DPoint    = (0, 1);
  NULLPoint: T2DPoint = (0, 0);
  ZeroPoint: T2DPoint = (0, 0);
  NULLRect: T2DRect   = ((0, 0), (0, 0));
  ZeroRect: T2DRect   = ((0, 0), (0, 0));

const
  RightHandSide        = -1;
  LeftHandSide         = +1;
  CollinearOrientation = 0;
  AboveOrientation     = +1;
  BelowOrientation     = -1;
  CoplanarOrientation  = 0;

function RangeValue(const v, minv, maxv: TGeoFloat): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function ClampValue(const v, minv, maxv: TGeoFloat): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function MaxValue(const v1, v2: TGeoFloat): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF}
function MinValue(const v1, v2: TGeoFloat): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF}
function MakePoint(const X, Y: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function MakePoint(const X, Y: Integer): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Point2Point(const pt: T2DPoint): TPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Point2Pointf(const pt: T2DPoint): TPointf; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointMake(const X, Y: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointMake(const pt: TPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointMake(const pt: TPointf): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Make2DPoint(const X, Y: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Make2DPoint(const X, Y: Integer): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Make2DPoint(const pt: TPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Make2DPoint(const pt: TPointf): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function MakePointf(const pt: T2DPoint): TPointf; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function IsZero(const v: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function IsZero(const pt: T2DPoint): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function IsZero(const r: T2DRect): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function IsNan(const pt: T2DPoint): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function IsNan(const X, Y: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function HypotX(const X, Y: Extended): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function PointNorm(const v: T2DPoint): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointNegate(const v: T2DPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

procedure SetPoint(var v: T2DPoint; const vSrc: T2DPoint); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointAdd(const v1, v2: T2DPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointAdd(const v1: T2DPoint; v2: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointAdd(const v1: T2DPoint; X, Y: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointSub(const v1, v2: T2DPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointSub(const v1: T2DPoint; v2: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function PointMul(const v1, v2: T2DPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointMul(const v1, v2: T2DPoint; const v3: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointMul(const v1, v2: T2DPoint; const v3, v4: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointMul(const v1, v2, v3: T2DPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointMul(const v1, v2, v3, v4: T2DPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointMul(const v1: T2DPoint; const v2: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointMul(const v1: T2DPoint; const v2, v3: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointMul(const v1: T2DPoint; const v2, v3, v4: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function PointDiv(const v1: T2DPoint; const v2: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointNormalize(const v: T2DPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointLength(const v: T2DPoint): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
procedure ScalePoint(var v: T2DPoint; factor: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointDotProduct(const v1, v2: T2DPoint): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Distance(const x1, y1, x2, y2: TGeoFloat): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Distance(const x1, y1, z1, x2, y2, z2: TGeoFloat): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointDistance(const x1, y1, x2, y2: TGeoFloat): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointDistance(const v1, v2: T2DPoint): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointLayDistance(const v1, v2: T2DPoint): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function SqrDistance(const v1, v2: T2DPoint): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointLerp(const v1, v2: T2DPoint; t: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointLerpTo(const sour, dest: T2DPoint; const d: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
procedure SwapPoint(var v1, v2: T2DPoint); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Pow(v: TGeoFloat): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function MidPoint(const pt1, pt2: T2DPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function IsEqual(const Val1, Val2, Epsilon: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function IsEqual(const Val1, Val2: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function IsEqual(const Val1, Val2: T2DPoint): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function IsEqual(const Val1, Val2: T2DPoint; Epsilon: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function IsEqual(const Val1, Val2: T2DRect): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function NotEqual(const Val1, Val2, Epsilon: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function NotEqual(const Val1, Val2: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function NotEqual(const Val1, Val2: T2DPoint): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function LessThanOrEqual(const Val1, Val2: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function GreaterThanOrEqual(const Val1, Val2: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function GetEquilateralTriangleCen(pt1, pt2: T2DPoint): T2DPoint; overload;

procedure Rotate(RotAng: TGeoFloat; const X, Y: TGeoFloat; out Nx, Ny: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Rotate(const RotAng: TGeoFloat; const Point: T2DPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function NormalizeDegAngle(angle: TGeoFloat): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

// axis to pt angle
function PointAngle(const axis, pt: T2DPoint): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
// null point to pt angle
function PointAngle(const pt: T2DPoint): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function AngleDistance(const s, a: TGeoFloat): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointRotation(const axis: T2DPoint; const Dist, angle: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointRotation(const axis, pt: T2DPoint; const angle: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function CircleInCircle(const cp1, cp2: T2DPoint; const r1, r2: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function CircleInRect(const cp: T2DPoint; const radius: TGeoFloat; r: T2DRect): Boolean;
function PointInRect(const Px, Py: TGeoFloat; const x1, y1, x2, y2: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointInRect(const Px, Py: TGeoInt; const x1, y1, x2, y2: TGeoInt): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointInRect(const pt: T2DPoint; const r: T2DRect): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointInRect(const Px, Py: TGeoFloat; const r: T2DRect): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectToRectIntersect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectToRectIntersect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoInt): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectToRectIntersect(const r1, r2: T2DRect): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectToRectIntersect(const r1, r2: TRect): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectToRectIntersect(const r1, r2: TRectf): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectWithinRect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectWithinRect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoInt): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectWithinRect(const r1, r2: T2DRect): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectWithinRect(const r1, r2: TRect): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function Make2DRect(const X, Y, radius: TGeoFloat): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Make2DRect(const x1, y1, x2, y2: TGeoFloat): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Make2DRect(const p1, p2: T2DPoint): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Make2DRect(const X, Y: TGeoFloat; const p2: T2DPoint): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Make2DRect(const r: TRect): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Make2DRect(const r: TRectf): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function MakeRect(const X, Y, radius: TGeoFloat): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function MakeRect(const x1, y1, x2, y2: TGeoFloat): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function MakeRect(const p1, p2: T2DPoint): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function MakeRect(const r: TRect): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function MakeRect(const r: TRectf): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Rect2Rect(const r: T2DRect): TRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Rect2Rect(const r: TRect): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function RectMake(const X, Y, radius: TGeoFloat): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectMake(const x1, y1, x2, y2: TGeoFloat): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectMake(const p1, p2: T2DPoint): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectMake(const r: TRect): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectMake(const r: TRectf): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function RectAdd(const r: T2DRect; pt: T2DPoint): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectAdd(const r1, r2: T2DRect): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectSub(const r1, r2: T2DRect): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectMul(const r1, r2: T2DRect): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectMul(const r1: T2DRect; r2: TGeoFloat): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectOffset(const r: T2DRect; offset: T2DPoint): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectSizeLerp(const r: T2DRect; const rSizeLerp: TGeoFloat): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectCenScale(const r: T2DRect; const rSizeScale: TGeoFloat): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectEndge(const r: T2DRect; const endge: TGeoFloat): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectEndge(const r: T2DRect; const endge: T2DPoint): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function RectCentre(const r: T2DRect): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

procedure FixRect(var Left, Top, Right, Bottom: Integer); overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
procedure FixRect(var Left, Top, Right, Bottom: TGeoFloat); overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
function FixRect(r: T2DRect): T2DRect; overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}

function MakeRect(const r: T2DRect): TRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function MakeRectf(const r: T2DRect): TRectf; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function RectWidth(const r: T2DRect): TGeoFloat; overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
function RectHeight(const r: T2DRect): TGeoFloat; overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}

function RectArea(const r: T2DRect): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF}
function RectSize(const r: T2DRect): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF}
function RectFit(const r, b: T2DRect): T2DRect; overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
function RectFit(const width, height: TGeoFloat; const b: T2DRect): T2DRect; overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
function BoundRect(const Buff: TArray2DPoint): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function BoundRect(const p1, p2, p3, p4: T2DPoint): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function BoundRect(const r1, r2: T2DRect): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function BuffCentroid(const Buff: TArray2DPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function BuffCentroid(const p1, p2, p3, p4: T2DPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function FastRamerDouglasPeucker(var Points: TArray2DPoint; Epsilon: TGeoFloat): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
procedure FastVertexReduction(Points: TArray2DPoint; Epsilon: TGeoFloat; var output: TArray2DPoint);

function Clip(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoFloat; out Cx1, Cy1, Cx2, Cy2: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Clip(const r1, r2: T2DRect; out r3: T2DRect): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function Orientation(const x1, y1, x2, y2, Px, Py: TGeoFloat): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Orientation(const x1, y1, z1, x2, y2, z2, x3, y3, z3, Px, Py, Pz: TGeoFloat): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Coplanar(const x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function SimpleIntersect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function SimpleIntersect(const Point1, Point2, Point3, Point4: T2DPoint): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Intersect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Intersect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoFloat; out ix, iy: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Intersect(const pt1, pt2, pt3, pt4: T2DPoint; out pt: T2DPoint): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Intersect(const pt1, pt2, pt3, pt4: T2DPoint): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function PointInCircle(const pt, cp: T2DPoint; radius: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

procedure ClosestPointOnSegmentFromPoint(const x1, y1, x2, y2, Px, Py: TGeoFloat; out Nx, Ny: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function ClosestPointOnSegmentFromPoint(const lb, le, pt: T2DPoint): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function MinimumDistanceFromPointToLine(const Px, Py, x1, y1, x2, y2: TGeoFloat): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function Quadrant(const angle: TGeoFloat): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

procedure ProjectPoint(const Srcx, Srcy, Dstx, Dsty, Dist: TGeoFloat; out Nx, Ny: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
procedure ProjectPoint(const Srcx, Srcy, Srcz, Dstx, Dsty, Dstz, Dist: TGeoFloat; out Nx, Ny, Nz: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
procedure ProjectPoint(const Px, Py, angle, Distance: TGeoFloat; out Nx, Ny: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

procedure ProjectPoint0(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
procedure ProjectPoint45(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
procedure ProjectPoint90(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
procedure ProjectPoint135(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
procedure ProjectPoint180(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
procedure ProjectPoint225(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
procedure ProjectPoint270(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
procedure ProjectPoint315(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function ProjectPoint0(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function ProjectPoint45(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function ProjectPoint90(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function ProjectPoint135(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function ProjectPoint180(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function ProjectPoint225(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function ProjectPoint270(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function ProjectPoint315(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function GetCicleRadiusInPolyEndge(r: TGeoFloat; PolySlices: Integer): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF}

procedure Circle2LineIntersectionPoint(const lb, le, cp: T2DPoint; const radius: TGeoFloat;
  out pt1in, pt2in: Boolean; out ICnt: Integer; out pt1, pt2: T2DPoint);

procedure Circle2CircleIntersectionPoint(const cp1, cp2: T2DPoint; const r1, r2: TGeoFloat; out Point1, Point2: T2DPoint); {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

// circle collision check
function Check_Circle2Circle(const p1, p2: T2DPoint; const r1, r2: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
function CircleCollision(const p1, p2: T2DPoint; const r1, r2: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

function Check_Circle2CirclePoint(const p1, p2: T2DPoint; const r1, r2: TGeoFloat; out op1, op2: T2DPoint): Boolean;
// circle 2 line collision
function Check_Circle2Line(const cp: T2DPoint; const r: TGeoFloat; const lb, le: T2DPoint): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;

type
  T2DPointList = class;
  TPoly        = class;
  T2DLineList  = class;

  T2DPointList = class(TCoreClassPersistent)
  private
    FList      : TCoreClassList;
    FUserData  : Pointer;
    FUserObject: TCoreClassObject;

    function GetPoints(Index: Integer): P2DPoint;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(X, Y: TGeoFloat); overload;
    procedure Add(pt: T2DPoint); overload;
    procedure AddSubdivision(nbCount: Integer; pt: T2DPoint); overload;
    procedure AddSubdivisionWithDistance(avgDist: TGeoFloat; pt: T2DPoint); overload;
    procedure Insert(idx: Integer; X, Y: TGeoFloat); overload;
    procedure Delete(idx: Integer); overload;
    procedure Clear; overload;
    function Count: Integer; overload;
    procedure FixedSameError;

    procedure Assign(Source: TCoreClassPersistent); override;

    procedure SaveToStream(Stream: TCoreClassStream); overload;
    procedure LoadFromStream(Stream: TCoreClassStream); overload;

    function BoundRect: T2DRect; overload;
    function CircleRadius(ACentroid: T2DPoint): TGeoFloat; overload;
    function Centroid: T2DPoint; overload;

    function PointInHere(pt: T2DPoint): Boolean; overload;

    procedure RotateAngle(axis: T2DPoint; angle: TGeoFloat); overload;

    procedure Scale(axis: T2DPoint; Scale: TGeoFloat); overload;

    procedure ConvexHull(output: T2DPointList); overload;

    procedure ExtractToBuff(var output: TArray2DPoint); overload;
    procedure GiveListDataFromBuff(output: PArray2DPoint); overload;
    procedure VertexReduction(Epsilon: TGeoFloat); overload;

    function Line2Intersect(const lb, le: T2DPoint; ClosedPolyMode: Boolean; OutputPoint: T2DPointList): Boolean; overload;
    function Line2NearIntersect(const lb, le: T2DPoint; const ClosedPolyMode: Boolean; out idx1, idx2: Integer; out IntersectPt: T2DPoint): Boolean; overload;

    procedure SortOfNear(const pt: T2DPoint); overload;
    procedure SortOfFar(const pt: T2DPoint); overload;

    procedure Reverse; overload;

    procedure AddCirclePoint(ACount: Cardinal; axis: T2DPoint; ADist: TGeoFloat);
    procedure AddRectangle(r: T2DRect);

    function GetMinimumFromPointToLine(const pt: T2DPoint; const ClosedMode: Boolean; out lb, le: Integer): T2DPoint; overload;
    function GetMinimumFromPointToLine(const pt: T2DPoint; const ClosedMode: Boolean): T2DPoint; overload;
    function GetMinimumFromPointToLine(const pt: T2DPoint; const ExpandDist: TGeoFloat): T2DPoint; overload;
    procedure CutLineBeginPtToIdx(const pt: T2DPoint; const toidx: Integer);

    procedure Translation(X, Y: TGeoFloat); overload;
    procedure Mul(X, Y: TGeoFloat); overload;

    property Items[index: Integer]: P2DPoint read GetPoints;
    property Points[index: Integer]: P2DPoint read GetPoints; default;
    function First: P2DPoint;
    function Last: P2DPoint;

    procedure ExpandDistanceAsList(ExpandDist: TGeoFloat; output: T2DPointList);
    procedure ExpandConvexHullAsList(ExpandDist: TGeoFloat; output: T2DPointList);

    function GetExpands(idx: Integer; ExpandDist: TGeoFloat): T2DPoint;
    property Expands[idx: Integer; ExpandDist: TGeoFloat]: T2DPoint read GetExpands;

    property UserData: Pointer read FUserData write FUserData;
    property UserObject: TCoreClassObject read FUserObject write FUserObject;
  end;

  PPolyPoint = ^TPolyPoint;

  TPolyPoint = packed record
    Owner: TPoly;
    angle: TGeoFloat;
    Dist: TGeoFloat;
  end;

  TExpandMode = (emConvex, emConcave);

  TPoly = class(TCoreClassPersistent)
  private
    FList      : TCoreClassList;
    FScale     : TGeoFloat;
    FAngle     : TGeoFloat;
    FMaxRadius : TGeoFloat;
    FPosition  : T2DPoint;
    FExpandMode: TExpandMode;

    FUserDataObject: TCoreClassObject;
    FUserData      : Pointer;

    function GetPoly(Index: Integer): PPolyPoint;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Reset; overload;

    procedure Assign(Source: TCoreClassPersistent); override;

    procedure AddPoint(pt: T2DPoint); overload;
    procedure AddPoint(X, Y: TGeoFloat); overload;
    procedure Add(AAngle, ADist: TGeoFloat); overload;
    procedure Insert(idx: Integer; angle, Dist: TGeoFloat); overload;
    procedure Delete(idx: Integer); overload;
    procedure Clear; overload;
    function Count: Integer; overload;
    procedure CopyPoly(pl: TPoly; AReversed: Boolean);
    procedure CopyExpandPoly(pl: TPoly; AReversed: Boolean; Dist: TGeoFloat);
    procedure Reverse;
    function ScaleBeforeDistance: TGeoFloat;
    function ScaleAfterDistance: TGeoFloat;

    procedure FixedSameError;

    { * auto build opt from convex hull point * }
    procedure ConvexHullFromPoint(AFrom: T2DPointList); overload;
    procedure RebuildPoly(pl: T2DPointList); overload;
    procedure RebuildPoly; overload;
    procedure RebuildPoly(AScale: TGeoFloat; AAngle: TGeoFloat; AExpandMode: TExpandMode; APosition: T2DPoint); overload;

    function BoundRect: T2DRect; overload;
    function Centroid: T2DPoint; overload;

    { * fast line intersect * }
    function PointInHere(pt: T2DPoint): Boolean; overload;
    function LineNearIntersect(const lb, le: T2DPoint; const ClosedPolyMode: Boolean;
      out idx1, idx2: Integer; out IntersectPt: T2DPoint): Boolean; overload;
    function LineIntersect(const lb, le: T2DPoint; const ClosedPolyMode: Boolean): Boolean; overload;
    function GetMinimumFromPointToPoly(const pt: T2DPoint; const ClosedPolyMode: Boolean; out lb, le: Integer): T2DPoint; overload;

    { * expand intersect * }
    function PointInHere(AExpandDistance: TGeoFloat; pt: T2DPoint): Boolean; overload;
    function LineNearIntersect(AExpandDistance: TGeoFloat; const lb, le: T2DPoint; const ClosedPolyMode: Boolean;
      out idx1, idx2: Integer; out IntersectPt: T2DPoint): Boolean; overload;
    function LineIntersect(AExpandDistance: TGeoFloat; const lb, le: T2DPoint; const ClosedPolyMode: Boolean): Boolean; overload;

    function GetMinimumFromPointToPoly(AExpandDistance: TGeoFloat; const pt: T2DPoint; const ClosedPolyMode: Boolean; out lb, le: Integer): T2DPoint; overload;

    function Collision2Circle(cp: T2DPoint; r: TGeoFloat; ClosedPolyMode: Boolean): Boolean; overload;
    function Collision2Circle(cp: T2DPoint; r: TGeoFloat; ClosedPolyMode: Boolean; OutputLine: T2DLineList): Boolean; overload;
    function Collision2Circle(AExpandDistance: TGeoFloat; cp: T2DPoint; r: TGeoFloat; ClosedPolyMode: Boolean; OutputLine: T2DLineList): Boolean; overload;

    function PolyIntersect(APoly: TPoly): Boolean;

    function LerpToOfEndge(pt: T2DPoint; AProjDistance, AExpandDistance: TGeoFloat; FromIdx, toidx: Integer): T2DPoint;

    property Scale: TGeoFloat read FScale write FScale;
    property angle: TGeoFloat read FAngle write FAngle;
    property Poly[index: Integer]: PPolyPoint read GetPoly;
    property Position: T2DPoint read FPosition write FPosition;
    property MaxRadius: TGeoFloat read FMaxRadius;
    property ExpandMode: TExpandMode read FExpandMode write FExpandMode;

    function GetPoint(idx: Integer): T2DPoint;
    procedure SetPoint(idx: Integer; Value: T2DPoint);
    property Points[idx: Integer]: T2DPoint read GetPoint write SetPoint; default;

    function GetExpands(idx: Integer; ExpandDist: TGeoFloat): T2DPoint;
    property Expands[idx: Integer; ExpandDist: TGeoFloat]: T2DPoint read GetExpands;

    procedure SaveToStream(Stream: TCoreClassStream); overload;
    procedure LoadFromStream(Stream: TCoreClassStream); overload;

    property UserDataObject: TCoreClassObject read FUserDataObject write FUserDataObject;
    property UserData: Pointer read FUserData write FUserData;
  end;

  T2DLine = packed record
    Buff: array [0 .. 1] of T2DPoint;
    Poly: TPoly;
    PolyIndex: array [0 .. 1] of Integer;
    Index: Integer;
  public
    procedure SetLocation(const lb, le: T2DPoint);
    function ExpandPoly(ExpandDist: TGeoFloat): T2DLine;
    function Length: TGeoFloat;
    function MinimumDistance(const pt: T2DPoint): TGeoFloat; overload;
    function MinimumDistance(ExpandDist: TGeoFloat; const pt: T2DPoint): TGeoFloat; overload;
    function ClosestPointFromLine(const pt: T2DPoint): T2DPoint; overload;
    function ClosestPointFromLine(ExpandDist: TGeoFloat; const pt: T2DPoint): T2DPoint; overload;
    function MiddlePoint: T2DPoint;
  end;

  P2DLine = ^T2DLine;

  T2DLineList = class(TCoreClassPersistent)
  private
    FList      : TCoreClassList;
    FUserData  : Pointer;
    FUserObject: TCoreClassObject;
    function GetItems(Index: Integer): P2DLine;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TCoreClassPersistent); override;

    property Items[index: Integer]: P2DLine read GetItems; default;
    function Add(v: T2DLine): Integer; overload;
    function Add(lb, le: T2DPoint): Integer; overload;
    function Add(lb, le: T2DPoint; idx1, idx2: Integer; Poly: TPoly): Integer; overload;
    function Count: Integer;
    procedure Clear;
    procedure Delete(Index: Integer);

    function NearLine(const ExpandDist: TGeoFloat; const pt: T2DPoint): P2DLine;
    function FarLine(const ExpandDist: TGeoFloat; const pt: T2DPoint): P2DLine;

    procedure SortOfNear(const pt: T2DPoint); overload;
    procedure SortOfFar(const pt: T2DPoint); overload;

    property UserData: Pointer read FUserData write FUserData;
    property UserObject: TCoreClassObject read FUserObject write FUserObject;
  end;

  P2DCircle = ^T2DCircle;

  T2DCircle = packed record
    Position: T2DPoint;
    radius: TGeoFloat;
    UserData: TCoreClassObject;
  end;

  T2DCircleList = class(TCoreClassPersistent)
  private
    FList: TCoreClassList;
    function GetItems(Index: Integer): P2DCircle;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TCoreClassPersistent); override;

    property Items[index: Integer]: P2DCircle read GetItems; default;
    function Add(const v: T2DCircle): Integer; overload;
    function Add(const Position: T2DPoint; const radius: TGeoFloat; const UserData: TCoreClassObject): Integer; overload;
    function Count: Integer;
    procedure Clear;
    procedure Delete(Index: Integer);

    procedure SortOfMinRadius;
    procedure SortOfMaxRadius;
  end;

  T2DRectList = class(TCoreClassPersistent)
  private
    FList: TCoreClassList;
    function GetItems(Index: Integer): P2DRect;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TCoreClassPersistent); override;

    property Items[index: Integer]: P2DRect read GetItems; default;
    function Add(const v: T2DRect): Integer; overload;
    function Count: Integer;
    procedure Clear;
    procedure Delete(Index: Integer);
  end;

  TPolyRect = packed record
    LeftTop: T2DPoint;
    RightTop: T2DPoint;
    RightBottom: T2DPoint;
    LeftBottom: T2DPoint;
  public
    function IsZero: Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Rotation(angle: TGeoFloat): TPolyRect; overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Rotation(axis: T2DPoint; angle: TGeoFloat): TPolyRect; overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Add(v: T2DPoint): TPolyRect; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Sub(v: T2DPoint): TPolyRect; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Mul(v: T2DPoint): TPolyRect; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function MoveTo(Position: T2DPoint): TPolyRect; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function BoundRect: T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function BoundRectf: TRectf; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Centroid: T2DPoint; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    class function Init(r: T2DRect; Ang: TGeoFloat): TPolyRect; overload; static; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    class function Init(r: TRectf; Ang: TGeoFloat): TPolyRect; overload; static; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    class function Init(r: TRect; Ang: TGeoFloat): TPolyRect; overload; static; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    class function Init(CenPos: T2DPoint; width, height, Ang: TGeoFloat): TPolyRect; overload; static; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    class function Init(width, height, Ang: TGeoFloat): TPolyRect; overload; static; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    class function InitZero: TPolyRect; static;
  end;

  TRectPackData = packed record
    rect: T2DRect;
    error: Boolean;
    Data1: Pointer;
    Data2: TCoreClassObject;
  end;

  PRectPackData = ^TRectPackData;

  TRectPacking = class(TCoreClassPersistent)
  private
    FList: TCoreClassList;
    function Pack(width, height: TGeoFloat; var X, Y: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function GetItems(const Index: Integer): PRectPackData;
  public
    MaxWidth, MaxHeight: TGeoFloat;

    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Add(const X, Y, width, height: TGeoFloat); overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    procedure Add(Data1: Pointer; Data2: TCoreClassObject; X, Y, width, height: TGeoFloat); overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    procedure Add(Data1: Pointer; Data2: TCoreClassObject; r: T2DRect); overload; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Data1Exists(const Data1: Pointer): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Data2Exists(const Data2: TCoreClassObject): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Count: Integer;
    property Items[const index: Integer]: PRectPackData read GetItems; default;

    procedure Build(SpaceWidth, SpaceHeight: TGeoFloat);
  end;

implementation

uses DataFrameEngine;

const
  // Epsilon
  Epsilon  = 1.0E-12;
  Zero     = 0.0;
  PIDiv180 = 0.017453292519943295769236907684886;

procedure T2DLine.SetLocation(const lb, le: T2DPoint);
begin
  Buff[0] := lb;
  Buff[1] := le;
end;

function T2DLine.ExpandPoly(ExpandDist: TGeoFloat): T2DLine;
begin
  Result := Self;
  if Poly <> nil then
    begin
      Result.Buff[0] := Poly.Expands[PolyIndex[0], ExpandDist];
      Result.Buff[1] := Poly.Expands[PolyIndex[1], ExpandDist];
    end;
end;

function T2DLine.Length: TGeoFloat;
begin
  Result := PointDistance(Buff[0], Buff[1]);
end;

function T2DLine.MinimumDistance(const pt: T2DPoint): TGeoFloat;
begin
  Result := PointDistance(pt, ClosestPointFromLine(pt));
end;

function T2DLine.MinimumDistance(ExpandDist: TGeoFloat; const pt: T2DPoint): TGeoFloat;
begin
  Result := PointDistance(pt, ClosestPointFromLine(ExpandDist, pt));
end;

function T2DLine.ClosestPointFromLine(const pt: T2DPoint): T2DPoint;
begin
  Result := ClosestPointOnSegmentFromPoint(Buff[0], Buff[1], pt);
end;

function T2DLine.ClosestPointFromLine(ExpandDist: TGeoFloat; const pt: T2DPoint): T2DPoint;
var
  e: T2DLine;
begin
  e := ExpandPoly(ExpandDist);
  Result := ClosestPointOnSegmentFromPoint(e.Buff[0], e.Buff[1], pt);
end;

function T2DLine.MiddlePoint: T2DPoint;
begin
  Result := MidPoint(Buff[0], Buff[1]);
end;

{$IFDEF FPC}


function Pointf(X, Y: TGeoFloat): TPointf;
begin
  Result.X := X;
  Result.Y := Y;
end;

function Rectf(Left, Top, Right, Bottom: TGeoFloat): TRectf;
begin
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Right;
  Result.Bottom := Bottom;
end;

{$ENDIF}


function RangeValue(const v, minv, maxv: TGeoFloat): TGeoFloat;
begin
  if v < minv then
      Result := minv
  else if v > maxv then
      Result := maxv
  else
      Result := v;
end;

function ClampValue(const v, minv, maxv: TGeoFloat): TGeoFloat;
begin
  if v < minv then
      Result := minv
  else if v > maxv then
      Result := maxv
  else
      Result := v;
end;

function MaxValue(const v1, v2: TGeoFloat): TGeoFloat;
begin
  if v1 > v2 then
      Result := v1
  else
      Result := v2;
end;

function MinValue(const v1, v2: TGeoFloat): TGeoFloat;
begin
  if v1 < v2 then
      Result := v1
  else
      Result := v2;
end;

function MakePoint(const X, Y: TGeoFloat): T2DPoint;
begin
  Result[0] := X;
  Result[1] := Y;
end;

function MakePoint(const X, Y: Integer): T2DPoint;
begin
  Result[0] := X;
  Result[1] := Y;
end;

function Point2Point(const pt: T2DPoint): TPoint;
begin
  Result.X := Round(pt[0]);
  Result.Y := Round(pt[1]);
end;

function Point2Pointf(const pt: T2DPoint): TPointf;
begin
  Result.X := pt[0];
  Result.Y := pt[1];
end;

function PointMake(const X, Y: TGeoFloat): T2DPoint;
begin
  Result[0] := X;
  Result[1] := Y;
end;

function PointMake(const pt: TPoint): T2DPoint;
begin
  Result[0] := pt.X;
  Result[1] := pt.Y;
end;

function PointMake(const pt: TPointf): T2DPoint;
begin
  Result[0] := pt.X;
  Result[1] := pt.Y;
end;

function Make2DPoint(const X, Y: TGeoFloat): T2DPoint;
begin
  Result[0] := X;
  Result[1] := Y;
end;

function Make2DPoint(const X, Y: Integer): T2DPoint;
begin
  Result[0] := X;
  Result[1] := Y;
end;

function Make2DPoint(const pt: TPoint): T2DPoint;
begin
  Result[0] := pt.X;
  Result[1] := pt.Y;
end;

function Make2DPoint(const pt: TPointf): T2DPoint;
begin
  Result[0] := pt.X;
  Result[1] := pt.Y;
end;

function MakePointf(const pt: T2DPoint): TPointf;
begin
  Result.X := pt[0];
  Result.Y := pt[1];
end;

function IsZero(const v: TGeoFloat): Boolean;
begin
  Result := IsEqual(v, 0, Epsilon);
end;

function IsZero(const pt: T2DPoint): Boolean;
begin
  Result := IsEqual(pt[0], 0, Epsilon) and IsEqual(pt[1], 0, Epsilon);
end;

function IsZero(const r: T2DRect): Boolean;
begin
  Result := IsZero(r[0]) and IsZero(r[1]);
end;

function IsNan(const pt: T2DPoint): Boolean;
begin
  Result := Math.IsNan(pt[0]) or Math.IsNan(pt[1]);
end;

function IsNan(const X, Y: TGeoFloat): Boolean;
begin
  Result := Math.IsNan(X) or Math.IsNan(Y);
end;

function HypotX(const X, Y: Extended): TGeoFloat;
{ formula: Sqrt(X*X + Y*Y)
  implemented as:  |Y|*Sqrt(1+Sqr(X/Y)), |X| < |Y| for greater precision }
var
  temp, TempX, TempY: Extended;
begin
  TempX := Abs(X);
  TempY := Abs(Y);
  if TempX > TempY then
    begin
      temp := TempX;
      TempX := TempY;
      TempY := temp;
    end;
  if TempX = 0 then
      Result := TempY
  else // TempY > TempX, TempX <> 0, so TempY > 0
      Result := TempY * Sqrt(1 + Sqr(TempX / TempY));
end;

function PointNorm(const v: T2DPoint): TGeoFloat;
begin
  Result := v[0] * v[0] + v[1] * v[1];
end;

function PointNegate(const v: T2DPoint): T2DPoint;
begin
  Result[0] := -v[0];
  Result[1] := -v[1];
end;

procedure SetPoint(var v: T2DPoint; const vSrc: T2DPoint);
begin
  v[0] := vSrc[0];
  v[1] := vSrc[1];
end;

function PointAdd(const v1, v2: T2DPoint): T2DPoint;
begin
  Result[0] := v1[0] + v2[0];
  Result[1] := v1[1] + v2[1];
end;

function PointAdd(const v1: T2DPoint; v2: TGeoFloat): T2DPoint;
begin
  Result[0] := v1[0] + v2;
  Result[1] := v1[1] + v2;
end;

function PointAdd(const v1: T2DPoint; X, Y: TGeoFloat): T2DPoint;
begin
  Result[0] := v1[0] + X;
  Result[1] := v1[1] + Y;
end;

function PointSub(const v1, v2: T2DPoint): T2DPoint;
begin
  Result[0] := v1[0] - v2[0];
  Result[1] := v1[1] - v2[1];
end;

function PointSub(const v1: T2DPoint; v2: TGeoFloat): T2DPoint;
begin
  Result[0] := v1[0] - v2;
  Result[1] := v1[1] - v2;
end;

function PointMul(const v1, v2: T2DPoint): T2DPoint;
begin
  Result[0] := v1[0] * v2[0];
  Result[1] := v1[1] * v2[1];
end;

function PointMul(const v1, v2: T2DPoint; const v3: TGeoFloat): T2DPoint;
begin
  Result[0] := v1[0] * v2[0] * v3;
  Result[1] := v1[1] * v2[1] * v3;
end;

function PointMul(const v1, v2: T2DPoint; const v3, v4: TGeoFloat): T2DPoint;
begin
  Result[0] := v1[0] * v2[0] * v3 * v4;
  Result[1] := v1[1] * v2[1] * v3 * v4;
end;

function PointMul(const v1, v2, v3: T2DPoint): T2DPoint;
begin
  Result[0] := v1[0] * v2[0] * v3[0];
  Result[1] := v1[1] * v2[1] * v3[1];
end;

function PointMul(const v1, v2, v3, v4: T2DPoint): T2DPoint;
begin
  Result[0] := v1[0] * v2[0] * v3[0] * v4[0];
  Result[1] := v1[1] * v2[1] * v3[1] * v4[1];
end;

function PointMul(const v1: T2DPoint; const v2: TGeoFloat): T2DPoint;
begin
  Result[0] := v1[0] * v2;
  Result[1] := v1[1] * v2;
end;

function PointMul(const v1: T2DPoint; const v2, v3: TGeoFloat): T2DPoint;
begin
  Result[0] := v1[0] * v2 * v3;
  Result[1] := v1[1] * v2 * v3;
end;

function PointMul(const v1: T2DPoint; const v2, v3, v4: TGeoFloat): T2DPoint;
begin
  Result[0] := v1[0] * v2 * v3 * v4;
  Result[1] := v1[1] * v2 * v3 * v4;
end;

function PointDiv(const v1: T2DPoint; const v2: TGeoFloat): T2DPoint;
begin
  Result[0] := v1[0] / v2;
  Result[1] := v1[1] / v2;
end;

function PointNormalize(const v: T2DPoint): T2DPoint;
var
  invLen: TGeoFloat;
  vn    : TGeoFloat;
begin
  vn := PointNorm(v);
  if vn = 0 then
      SetPoint(Result, v)
  else
    begin
      invLen := 1 / Sqrt(vn);
      Result[0] := v[0] * invLen;
      Result[1] := v[1] * invLen;
    end;
end;

function PointLength(const v: T2DPoint): TGeoFloat;
begin
  Result := Sqrt(PointNorm(v));
end;

procedure ScalePoint(var v: T2DPoint; factor: TGeoFloat);
begin
  v[0] := v[0] * factor;
  v[1] := v[1] * factor;
end;

function PointDotProduct(const v1, v2: T2DPoint): TGeoFloat;
begin
  Result := v1[0] * v2[0] + v1[1] * v2[1];
end;

function Distance(const x1, y1, x2, y2: TGeoFloat): TGeoFloat;
begin
  Result := Sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
end;

function Distance(const x1, y1, z1, x2, y2, z2: TGeoFloat): TGeoFloat;
begin
  Result := Sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1));
end;

function PointDistance(const x1, y1, x2, y2: TGeoFloat): TGeoFloat;
begin
  Result := Sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
end;

function PointDistance(const v1, v2: T2DPoint): TGeoFloat;
begin
  Result := Sqrt((v2[0] - v1[0]) * (v2[0] - v1[0]) + (v2[1] - v1[1]) * (v2[1] - v1[1]));
end;

function PointLayDistance(const v1, v2: T2DPoint): TGeoFloat;
begin
  Result := Pow(v2[0] - v1[0]) + Pow(v2[1] - v1[1]);
end;

function SqrDistance(const v1, v2: T2DPoint): TGeoFloat;
begin
  Result := Sqr(v2[0] - v1[0]) + Sqr(v2[1] - v1[1]);
end;

function PointLerp(const v1, v2: T2DPoint; t: TGeoFloat): T2DPoint;
const
  X = 0;
  Y = 1;
begin
  Result[X] := v1[X] + (v2[X] - v1[X]) * t;
  Result[Y] := v1[Y] + (v2[Y] - v1[Y]) * t;
end;

function PointLerpTo(const sour, dest: T2DPoint; const d: TGeoFloat): T2DPoint;
var
  dx: TGeoFloat;
  dy: TGeoFloat;
  k : Double;
begin
  dx := dest[0] - sour[0];
  dy := dest[1] - sour[1];
  if ((dx <> 0) or (dy <> 0)) and (d <> 0) then
    begin
      k := d / Sqrt(dx * dx + dy * dy);
      Result[0] := sour[0] + k * dx;
      Result[1] := sour[1] + k * dy;
    end
  else
    begin
      Result := sour;
    end;
end;

procedure SwapPoint(var v1, v2: T2DPoint);
var
  v: T2DPoint;
begin
  v := v1;
  v1 := v2;
  v2 := v;
end;

function Pow(v: TGeoFloat): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
begin
  Result := v * v;
end;

function MidPoint(const pt1, pt2: T2DPoint): T2DPoint;
begin
  Result[0] := (pt1[0] + pt2[0]) * 0.5;
  Result[1] := (pt1[1] + pt2[1]) * 0.5;
end;

function IsEqual(const Val1, Val2, Epsilon: TGeoFloat): Boolean;
var
  Diff: TGeoFloat;
begin
  Diff := Val1 - Val2;
  Assert(((-Epsilon <= Diff) and (Diff <= Epsilon)) = (Abs(Diff) <= Epsilon), 'Error - Illogical error in equality check. (IsEqual)');
  Result := ((-Epsilon <= Diff) and (Diff <= Epsilon));
end;

function IsEqual(const Val1, Val2: TGeoFloat): Boolean;
begin
  Result := IsEqual(Val1, Val2, Epsilon);
end;

function IsEqual(const Val1, Val2: T2DPoint): Boolean;
begin
  Result := IsEqual(Val1[0], Val2[0]) and IsEqual(Val1[1], Val2[1]);
end;

function IsEqual(const Val1, Val2: T2DPoint; Epsilon: TGeoFloat): Boolean;
begin
  Result := IsEqual(Val1[0], Val2[0], Epsilon) and IsEqual(Val1[1], Val2[1], Epsilon);
end;

function IsEqual(const Val1, Val2: T2DRect): Boolean;
begin
  Result := IsEqual(Val1[0], Val2[0]) and IsEqual(Val1[1], Val2[1]);
end;

function NotEqual(const Val1, Val2, Epsilon: TGeoFloat): Boolean;
var
  Diff: TGeoFloat;
begin
  Diff := Val1 - Val2;
  Assert(((-Epsilon > Diff) or (Diff > Epsilon)) = (Abs(Val1 - Val2) > Epsilon), 'Error - Illogical error in equality check. (NotEqual)');
  Result := ((-Epsilon > Diff) or (Diff > Epsilon));
end;

function NotEqual(const Val1, Val2: TGeoFloat): Boolean;
begin
  Result := NotEqual(Val1, Val2, Epsilon);
end;

function NotEqual(const Val1, Val2: T2DPoint): Boolean;
begin
  Result := NotEqual(Val1[0], Val2[0]) or NotEqual(Val1[1], Val2[1]);
end;

function LessThanOrEqual(const Val1, Val2: TGeoFloat): Boolean;
begin
  Result := (Val1 < Val2) or IsEqual(Val1, Val2);
end;

function GreaterThanOrEqual(const Val1, Val2: TGeoFloat): Boolean;
begin
  Result := (Val1 > Val2) or IsEqual(Val1, Val2);
end;

function GetEquilateralTriangleCen(pt1, pt2: T2DPoint): T2DPoint;
const
  Sin60: TGeoFloat = 0.86602540378443864676372317075294;
  Cos60: TGeoFloat = 0.50000000000000000000000000000000;
var
  b, e, pt: T2DPoint;
begin
  b := pt1;
  e := pt2;
  e[0] := e[0] - b[0];
  e[1] := e[1] - b[1];
  pt[0] := ((e[0] * Cos60) - (e[1] * Sin60)) + b[0];
  pt[1] := ((e[1] * Cos60) + (e[0] * Sin60)) + b[1];
  Assert(Intersect(pt1, MidPoint(pt2, pt), pt2, MidPoint(pt1, pt), Result));
end;

procedure Rotate(RotAng: TGeoFloat; const X, Y: TGeoFloat; out Nx, Ny: TGeoFloat);
var
  SinVal: TGeoFloat;
  CosVal: TGeoFloat;
begin
  RotAng := RotAng * PIDiv180;
  SinVal := Sin(RotAng);
  CosVal := Cos(RotAng);
  Nx := (X * CosVal) - (Y * SinVal);
  Ny := (Y * CosVal) + (X * SinVal);
end;

function Rotate(const RotAng: TGeoFloat; const Point: T2DPoint): T2DPoint;
begin
  Rotate(RotAng, Point[0], Point[1], Result[0], Result[1]);
end;

function NormalizeDegAngle(angle: TGeoFloat): TGeoFloat;
begin
  Result := angle - Int(angle * (1 / 360)) * 360;
  if Result > 180 then
      Result := Result - 360
  else if Result < -180 then
      Result := Result + 360;
end;

function PointAngle(const axis, pt: T2DPoint): TGeoFloat;
begin
  Result := NormalizeDegAngle(RadToDeg(ArcTan2(axis[1] - pt[1], axis[0] - pt[0])));
end;

function PointAngle(const pt: T2DPoint): TGeoFloat;
begin
  Result := PointAngle(NULLPoint, pt);
end;

function AngleDistance(const s, a: TGeoFloat): TGeoFloat;
begin
  Result := Abs(s - a);
  if Result > 180 then
      Result := 360 - Result;
end;

function PointRotation(const axis: T2DPoint; const Dist, angle: TGeoFloat): T2DPoint;
begin
  Result[0] := axis[0] - (Cos(DegToRad(angle)) * Dist);
  Result[1] := axis[1] - (Sin(DegToRad(angle)) * Dist);
end;

function PointRotation(const axis, pt: T2DPoint; const angle: TGeoFloat): T2DPoint;
begin
  Result := PointRotation(axis, PointDistance(axis, pt), angle);
end;

function CircleInCircle(const cp1, cp2: T2DPoint; const r1, r2: TGeoFloat): Boolean;
begin
  Result := (r2 - (PointDistance(cp1, cp2) + r1) >= Zero);
end;

function CircleInRect(const cp: T2DPoint; const radius: TGeoFloat; r: T2DRect): Boolean;
begin
  FixRect(r[0][0], r[0][1], r[1][0], r[1][1]);
  Result := PointInRect(cp, MakeRect(PointSub(r[0], radius), PointAdd(r[1], radius)));
end;

function PointInRect(const Px, Py: TGeoFloat; const x1, y1, x2, y2: TGeoFloat): Boolean;
begin
  Result := ((x1 <= Px) and (Px <= x2) and (y1 <= Py) and (Py <= y2)) or ((x2 <= Px) and (Px <= x1) and (y2 <= Py) and (Py <= y1));
end;

function PointInRect(const Px, Py: TGeoInt; const x1, y1, x2, y2: TGeoInt): Boolean;
begin
  Result := ((x1 <= Px) and (Px <= x2) and (y1 <= Py) and (Py <= y2)) or ((x2 <= Px) and (Px <= x1) and (y2 <= Py) and (Py <= y1));
end;

function PointInRect(const pt: T2DPoint; const r: T2DRect): Boolean;
begin
  Result := PointInRect(pt[0], pt[1], r[0][0], r[0][1], r[1][0], r[1][1]);
end;

function PointInRect(const Px, Py: TGeoFloat; const r: T2DRect): Boolean;
begin
  Result := PointInRect(Px, Py, r[0][0], r[0][1], r[1][0], r[1][1]);
end;

function RectToRectIntersect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoFloat): Boolean;
begin
  Result := (x1 <= x4) and (x2 >= x3) and (y1 <= y4) and (y2 >= y3);
end;

function RectToRectIntersect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoInt): Boolean;
begin
  Result := (x1 <= x4) and (x2 >= x3) and (y1 <= y4) and (y2 >= y3);
end;

function RectToRectIntersect(const r1, r2: T2DRect): Boolean;
begin
  Result := RectToRectIntersect(r1[0][0], r1[0][1], r1[1][0], r1[1][1], r2[0][0], r2[0][1], r2[1][0], r2[1][1]);
end;

function RectToRectIntersect(const r1, r2: TRect): Boolean;
begin
  Result := RectToRectIntersect(r1.Left, r1.Top, r1.Right, r1.Bottom, r2.Left, r2.Top, r2.Right, r2.Bottom);
end;

function RectToRectIntersect(const r1, r2: TRectf): Boolean;
begin
  Result := RectToRectIntersect(r1.Left, r1.Top, r1.Right, r1.Bottom, r2.Left, r2.Top, r2.Right, r2.Bottom);
end;

function RectWithinRect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoFloat): Boolean;
begin
  Result := PointInRect(x1, y1, x3, y3, x4, y4) and PointInRect(x2, y2, x3, y3, x4, y4);
end;

function RectWithinRect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoInt): Boolean;
begin
  Result := PointInRect(x1, y1, x3, y3, x4, y4) and PointInRect(x2, y2, x3, y3, x4, y4);
end;

function RectWithinRect(const r1, r2: T2DRect): Boolean;
begin
  Result := RectWithinRect(r1[0][0], r1[0][1], r1[1][0], r1[1][1], r2[0][0], r2[0][1], r2[1][0], r2[1][1]);
end;

function RectWithinRect(const r1, r2: TRect): Boolean;
begin
  Result := RectWithinRect(r1.Left, r1.Top, r1.Right, r1.Bottom, r2.Left, r2.Top, r2.Right, r2.Bottom);
end;

function Make2DRect(const X, Y, radius: TGeoFloat): T2DRect;
begin
  Result[0][0] := X - radius;
  Result[0][1] := Y - radius;
  Result[1][0] := X + radius;
  Result[1][1] := Y + radius;
end;

function Make2DRect(const x1, y1, x2, y2: TGeoFloat): T2DRect;
begin
  Result[0][0] := x1;
  Result[0][1] := y1;
  Result[1][0] := x2;
  Result[1][1] := y2;
end;

function Make2DRect(const p1, p2: T2DPoint): T2DRect;
begin
  Result[0] := p1;
  Result[1] := p2;
end;

function Make2DRect(const X, Y: TGeoFloat; const p2: T2DPoint): T2DRect;
begin
  Result[0] := PointMake(X, Y);
  Result[1] := p2;
end;

function Make2DRect(const r: TRect): T2DRect;
begin
  Result[0][0] := r.Left;
  Result[0][1] := r.Top;
  Result[1][0] := r.Right;
  Result[1][1] := r.Bottom;
end;

function Make2DRect(const r: TRectf): T2DRect;
begin
  Result[0][0] := r.Left;
  Result[0][1] := r.Top;
  Result[1][0] := r.Right;
  Result[1][1] := r.Bottom;
end;

function MakeRect(const X, Y, radius: TGeoFloat): T2DRect;
begin
  Result[0][0] := X - radius;
  Result[0][1] := Y - radius;
  Result[1][0] := X + radius;
  Result[1][1] := Y + radius;
end;

function MakeRect(const x1, y1, x2, y2: TGeoFloat): T2DRect;
begin
  Result[0][0] := x1;
  Result[0][1] := y1;
  Result[1][0] := x2;
  Result[1][1] := y2;
end;

function MakeRect(const p1, p2: T2DPoint): T2DRect;
begin
  Result[0] := p1;
  Result[1] := p2;
end;

function MakeRect(const r: TRect): T2DRect;
begin
  Result[0][0] := r.Left;
  Result[0][1] := r.Top;
  Result[1][0] := r.Right;
  Result[1][1] := r.Bottom;
end;

function MakeRect(const r: TRectf): T2DRect;
begin
  Result[0][0] := r.Left;
  Result[0][1] := r.Top;
  Result[1][0] := r.Right;
  Result[1][1] := r.Bottom;
end;

function Rect2Rect(const r: T2DRect): TRect;
begin
  Result.Left := Trunc(r[0][0]);
  Result.Top := Trunc(r[0][1]);
  Result.Right := Trunc(r[1][0]);
  Result.Bottom := Trunc(r[1][1]);
end;

function Rect2Rect(const r: TRect): T2DRect;
begin
  Result[0][0] := r.Left;
  Result[0][1] := r.Top;
  Result[1][0] := r.Right;
  Result[1][1] := r.Bottom;
end;

function RectMake(const X, Y, radius: TGeoFloat): T2DRect;
begin
  Result[0][0] := X - radius;
  Result[0][1] := Y - radius;
  Result[1][0] := X + radius;
  Result[1][1] := Y + radius;
end;

function RectMake(const x1, y1, x2, y2: TGeoFloat): T2DRect;
begin
  Result[0][0] := x1;
  Result[0][1] := y1;
  Result[1][0] := x2;
  Result[1][1] := y2;
end;

function RectMake(const p1, p2: T2DPoint): T2DRect;
begin
  Result[0] := p1;
  Result[1] := p2;
end;

function RectMake(const r: TRect): T2DRect;
begin
  Result[0][0] := r.Left;
  Result[0][1] := r.Top;
  Result[1][0] := r.Right;
  Result[1][1] := r.Bottom;
end;

function RectMake(const r: TRectf): T2DRect;
begin
  Result[0][0] := r.Left;
  Result[0][1] := r.Top;
  Result[1][0] := r.Right;
  Result[1][1] := r.Bottom;
end;

function RectAdd(const r: T2DRect; pt: T2DPoint): T2DRect;
begin
  Result[0] := PointAdd(r[0], pt);
  Result[1] := PointAdd(r[1], pt);
end;

function RectAdd(const r1, r2: T2DRect): T2DRect;
begin
  Result[0] := PointAdd(r1[0], r2[0]);
  Result[1] := PointAdd(r1[1], r2[1]);
end;

function RectSub(const r1, r2: T2DRect): T2DRect;
begin
  Result[0] := PointSub(r1[0], r2[0]);
  Result[1] := PointSub(r1[1], r2[1]);
end;

function RectMul(const r1, r2: T2DRect): T2DRect;
begin
  Result[0] := PointMul(r1[0], r2[0]);
  Result[1] := PointMul(r1[1], r2[1]);
end;

function RectMul(const r1: T2DRect; r2: TGeoFloat): T2DRect;
begin
  Result[0] := PointMul(r1[0], r2);
  Result[1] := PointMul(r1[1], r2);
end;

function RectOffset(const r: T2DRect; offset: T2DPoint): T2DRect;
begin
  Result[0] := PointAdd(r[0], offset);
  Result[1] := PointAdd(r[1], offset);
end;

function RectSizeLerp(const r: T2DRect; const rSizeLerp: TGeoFloat): T2DRect;
begin
  Result[0] := r[0];
  Result[1] := PointLerp(r[0], r[1], rSizeLerp);
end;

function RectCenScale(const r: T2DRect; const rSizeScale: TGeoFloat): T2DRect;
var
  cen, siz: T2DPoint;
begin
  cen := PointLerp(r[0], r[1], 0.5);
  siz := PointMul(RectSize(r), rSizeScale);
  Result[0] := PointSub(cen, PointMul(siz, 0.5));
  Result[1] := PointAdd(cen, PointMul(siz, 0.5));
end;

function RectEndge(const r: T2DRect; const endge: TGeoFloat): T2DRect;
begin
  Result[0][0] := r[0][0] - endge;
  Result[0][1] := r[0][1] - endge;
  Result[1][0] := r[1][0] + endge;
  Result[1][1] := r[1][1] + endge;
end;

function RectEndge(const r: T2DRect; const endge: T2DPoint): T2DRect; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
begin
  Result[0][0] := r[0][0] - endge[0];
  Result[0][1] := r[0][1] - endge[1];
  Result[1][0] := r[1][0] + endge[0];
  Result[1][1] := r[1][1] + endge[1];
end;

function RectCentre(const r: T2DRect): T2DPoint;
begin
  Result := PointLerp(r[0], r[1], 0.5);
end;

procedure FixRect(var Left, Top, Right, Bottom: Integer);
  procedure Swap(var v1, v2: Integer); {$IFDEF INLINE_ASM} inline; {$ENDIF}
  var
    X: Integer;
  begin
    X := v1;
    v1 := v2;
    v2 := X;
  end;

begin
  if Bottom < Top then
      Swap(Bottom, Top);
  if Right < Left then
      Swap(Right, Left);
end;

procedure FixRect(var Left, Top, Right, Bottom: TGeoFloat);
  procedure Swap(var v1, v2: TGeoFloat); {$IFDEF INLINE_ASM} inline; {$ENDIF}
  var
    X: TGeoFloat;
  begin
    X := v1;
    v1 := v2;
    v2 := X;
  end;

begin
  if Bottom < Top then
      Swap(Bottom, Top);
  if Right < Left then
      Swap(Right, Left);
end;

function FixRect(r: T2DRect): T2DRect;
begin
  Result := r;
  FixRect(Result[0][0], Result[0][1], Result[1][0], Result[1][1]);
end;

function MakeRect(const r: T2DRect): TRect;
begin
  Result.Left := Round(r[0][0]);
  Result.Top := Round(r[0][1]);
  Result.Right := Round(r[1][0]);
  Result.Bottom := Round(r[1][1]);
end;

function MakeRectf(const r: T2DRect): TRectf;
begin
  Result.Left := r[0][0];
  Result.Top := r[0][1];
  Result.Right := r[1][0];
  Result.Bottom := r[1][1];
end;

function RectWidth(const r: T2DRect): TGeoFloat;
begin
  if r[1][0] > r[0][0] then
      Result := r[1][0] - r[0][0]
  else
      Result := r[0][0] - r[1][0];
end;

function RectHeight(const r: T2DRect): TGeoFloat;
begin
  if r[1][1] > r[0][1] then
      Result := r[1][1] - r[0][1]
  else
      Result := r[0][1] - r[1][1];
end;

function RectArea(const r: T2DRect): TGeoFloat;
begin
  Result := RectWidth(r) * RectHeight(r);
end;

function RectSize(const r: T2DRect): T2DPoint;
var
  n: T2DRect;
begin
  n := FixRect(r);
  Result := PointSub(n[1], n[0]);
end;

function RectFit(const r, b: T2DRect): T2DRect;
var
  k              : TGeoFloat;
  rs, bs, siz, pt: T2DPoint;
begin
  rs := RectSize(r);
  bs := RectSize(b);

  if (rs[0] / bs[0]) > (rs[1] / bs[1]) then
      k := rs[0] / bs[0]
  else
      k := rs[1] / bs[1];

  siz := PointDiv(rs, k);
  pt := PointMul(PointSub(bs, siz), 0.5);
  Result[0] := PointAdd(b[0], pt);
  Result[1] := PointAdd(Result[0], siz);
end;

function RectFit(const width, height: TGeoFloat; const b: T2DRect): T2DRect;
begin
  Result := RectFit(Make2DRect(0, 0, width, height), b);
end;

function BoundRect(const Buff: TArray2DPoint): T2DRect;
var
  t   : T2DPoint;
  MaxX: TGeoFloat;
  MaxY: TGeoFloat;
  MinX: TGeoFloat;
  MinY: TGeoFloat;
  i   : Integer;
begin
  Result := Make2DRect(Zero, Zero, Zero, Zero);
  if Length(Buff) < 2 then
      Exit;
  t := Buff[0];
  MinX := t[0];
  MaxX := t[0];
  MinY := t[1];
  MaxY := t[1];

  for i := 1 to Length(Buff) - 1 do
    begin
      t := Buff[i];
      if t[0] < MinX then
          MinX := t[0]
      else if t[0] > MaxX then
          MaxX := t[0];
      if t[1] < MinY then
          MinY := t[1]
      else if t[1] > MaxY then
          MaxY := t[1];
    end;
  Result := Make2DRect(MinX, MinY, MaxX, MaxY);
end;

function BoundRect(const p1, p2, p3, p4: T2DPoint): T2DRect;
{$IFDEF FPC}
var
  Buff: TArray2DPoint;
begin
  SetLength(Buff, 4);
  Buff[0] := p1;
  Buff[1] := p2;
  Buff[2] := p3;
  Buff[3] := p4;
  Result := BoundRect(Buff);
end;
{$ELSE}


begin
  Result := BoundRect([p1, p2, p3, p4]);
end;
{$ENDIF}


function BoundRect(const r1, r2: T2DRect): T2DRect;
begin
  Result := BoundRect(r1[0], r1[1], r2[0], r2[1]);
end;

function BuffCentroid(const Buff: TArray2DPoint): T2DPoint;
var
  i, Count: Integer;
  asum    : TGeoFloat;
  term    : TGeoFloat;

  t1, t2: T2DPoint;
begin
  Result := NULLPoint;
  Count := Length(Buff);

  if Count < 3 then
      Exit;

  asum := Zero;
  t2 := Buff[Count - 1];

  for i := 0 to Count - 1 do
    begin
      t1 := Buff[i];

      term := ((t2[0] * t1[1]) - (t2[1] * t1[0]));
      asum := asum + term;
      Result[0] := Result[0] + (t2[0] + t1[0]) * term;
      Result[1] := Result[1] + (t2[1] + t1[1]) * term;
      t2 := t1;
    end;

  if NotEqual(asum, Zero) then
    begin
      Result[0] := Result[0] / (3.0 * asum);
      Result[1] := Result[1] / (3.0 * asum);
    end;
end;

function BuffCentroid(const p1, p2, p3, p4: T2DPoint): T2DPoint;
{$IFDEF FPC}
var
  Buff: TArray2DPoint;
begin
  SetLength(Buff, 4);
  Buff[0] := p1;
  Buff[1] := p2;
  Buff[2] := p3;
  Buff[3] := p4;
  Result := BuffCentroid(Buff);
end;
{$ELSE}


begin
  Result := BuffCentroid([p1, p2, p3, p4]);
end;
{$ENDIF}


function FastRamerDouglasPeucker(var Points: TArray2DPoint; Epsilon: TGeoFloat): Integer;
var
  i             : Integer;
  Range         : array of Integer;
  FirstIndex    : Integer;
  LastIndex     : Integer;
  LastPoint     : T2DPoint;
  FirstLastDelta: T2DPoint;
  DeltaMaxIndex : Integer;
  Delta         : TGeoFloat;
  DeltaMax      : TGeoFloat;
begin
  Result := Length(Points);
  if Result < 3 then
      Exit;
  FirstIndex := 0;
  LastIndex := Result - 1;
  SetLength(Range, Result);
  Range[0] := LastIndex;
  Range[LastIndex] := -1;
  Result := 0;

  repeat
    if LastIndex - FirstIndex > 1 then
      begin
        // find the point with the maximum distance
        DeltaMax := 0;
        DeltaMaxIndex := 0;
        LastPoint := Points[LastIndex];
        FirstLastDelta := PointSub(Points[FirstIndex], LastPoint);
        for i := FirstIndex + 1 to LastIndex - 1 do
          begin
            Delta := Abs((Points[i][0] - LastPoint[0]) * FirstLastDelta[1] - (Points[i][1] - LastPoint[1]) * FirstLastDelta[0]);
            if Delta > DeltaMax then
              begin
                DeltaMaxIndex := i;
                DeltaMax := Delta;
              end;
          end;

        // if max distance is greater than epsilon, split ranges
        if DeltaMax >= Epsilon * HypotX(FirstLastDelta[0], FirstLastDelta[1]) then
          begin
            Range[FirstIndex] := DeltaMaxIndex;
            Range[DeltaMaxIndex] := LastIndex;
            LastIndex := DeltaMaxIndex;
            Continue;
          end;
      end;

    // Include First and Last points only
    if Result <> FirstIndex then
        Points[Result] := Points[FirstIndex];
    Inc(Result);
    if Result <> LastIndex then
        Points[Result] := Points[LastIndex];

    // Next range
    FirstIndex := Range[FirstIndex];
    LastIndex := Range[FirstIndex];

  until LastIndex < 0;
  Inc(Result);
end;

procedure FastVertexReduction(Points: TArray2DPoint; Epsilon: TGeoFloat; var output: TArray2DPoint);

  procedure FilterPoints;
  var
    Index     : Integer;
    Count     : Integer;
    SqrEpsilon: TGeoFloat;
  begin
    SqrEpsilon := Sqr(Epsilon);
    output := Points;
    Count := 1;
    for index := 1 to high(output) do
      begin
        if SqrDistance(output[Count - 1], Points[index]) > SqrEpsilon then
          begin
            if Count <> index then
                output[Count] := Points[index];
            Inc(Count);
          end;
      end;
    SetLength(output, Count);
  end;

var
  Count: Integer;
begin
  FilterPoints;

  Count := FastRamerDouglasPeucker(output, Epsilon);
  SetLength(output, Count);
end;

function Clip(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoFloat; out Cx1, Cy1, Cx2, Cy2: TGeoFloat): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF} overload;
begin
  if RectToRectIntersect(x1, y1, x2, y2, x3, y3, x4, y4) then
    begin
      Result := True;
      if x1 < x3 then
          Cx1 := x3
      else
          Cx1 := x1;

      if x2 > x4 then
          Cx2 := x4
      else
          Cx2 := x2;

      if y1 < y3 then
          Cy1 := y3
      else
          Cy1 := y1;

      if y2 > y4 then
          Cy2 := y4
      else
          Cy2 := y2;
    end
  else
      Result := False;
end;

function Clip(const r1, r2: T2DRect; out r3: T2DRect): Boolean;
begin
  Result := Clip(
    r1[0][0], r1[0][1], r1[1][0], r1[1][1],
    r2[0][0], r2[0][1], r2[1][0], r2[1][1],
    r3[0][0], r3[0][1], r3[1][0], r3[1][1]);
end;

function Orientation(const x1, y1, x2, y2, Px, Py: TGeoFloat): Integer;
var
  Orin: TGeoFloat;
begin
  (* Determinant of the 3 points *)
  Orin := (x2 - x1) * (Py - y1) - (Px - x1) * (y2 - y1);

  if Orin > Zero then
      Result := LeftHandSide (* Orientaion is to the left-hand side *)
  else if Orin < Zero then
      Result := RightHandSide (* Orientaion is to the right-hand side *)
  else
      Result := CollinearOrientation; (* Orientaion is neutral aka collinear *)
end;

function Orientation(const x1, y1, z1, x2, y2, z2, x3, y3, z3, Px, Py, Pz: TGeoFloat): Integer;
var
  Px1 : TGeoFloat;
  Px2 : TGeoFloat;
  Px3 : TGeoFloat;
  Py1 : TGeoFloat;
  Py2 : TGeoFloat;
  Py3 : TGeoFloat;
  Pz1 : TGeoFloat;
  Pz2 : TGeoFloat;
  Pz3 : TGeoFloat;
  Orin: TGeoFloat;
begin
  Px1 := x1 - Px;
  Px2 := x2 - Px;
  Px3 := x3 - Px;

  Py1 := y1 - Py;
  Py2 := y2 - Py;
  Py3 := y3 - Py;

  Pz1 := z1 - Pz;
  Pz2 := z2 - Pz;
  Pz3 := z3 - Pz;

  Orin := Px1 * (Py2 * Pz3 - Pz2 * Py3) +
    Px2 * (Py3 * Pz1 - Pz3 * Py1) +
    Px3 * (Py1 * Pz2 - Pz1 * Py2);

  if Orin < Zero then
      Result := BelowOrientation (* Orientaion is below plane *)
  else if Orin > Zero then
      Result := AboveOrientation (* Orientaion is above plane *)
  else
      Result := CoplanarOrientation; (* Orientaion is coplanar to plane if Result is 0 *)
end;

function Coplanar(const x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4: TGeoFloat): Boolean;
begin
  Result := (Orientation(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4) = CoplanarOrientation);
end;

function SimpleIntersect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoFloat): Boolean;
begin
  Result := (
    ((Orientation(x1, y1, x2, y2, x3, y3) * Orientation(x1, y1, x2, y2, x4, y4)) <= 0) and
    ((Orientation(x3, y3, x4, y4, x1, y1) * Orientation(x3, y3, x4, y4, x2, y2)) <= 0)
    );
end;

function SimpleIntersect(const Point1, Point2, Point3, Point4: T2DPoint): Boolean;
begin
  Result := SimpleIntersect(Point1[0], Point1[1], Point2[0], Point2[1], Point3[0], Point3[1], Point4[0], Point4[1]);
end;

function Intersect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoFloat): Boolean;
var
  UpperX: TGeoFloat;
  UpperY: TGeoFloat;
  LowerX: TGeoFloat;
  LowerY: TGeoFloat;
  Ax    : TGeoFloat;
  Bx    : TGeoFloat;
  Cx    : TGeoFloat;
  Ay    : TGeoFloat;
  By    : TGeoFloat;
  Cy    : TGeoFloat;
  d     : TGeoFloat;
  F     : TGeoFloat;
  e     : TGeoFloat;
begin
  Result := False;

  Ax := x2 - x1;
  Bx := x3 - x4;

  if Ax < Zero then
    begin
      LowerX := x2;
      UpperX := x1;
    end
  else
    begin
      UpperX := x2;
      LowerX := x1;
    end;

  if Bx > Zero then
    begin
      if (UpperX < x4) or (x3 < LowerX) then
          Exit;
    end
  else if (UpperX < x3) or (x4 < LowerX) then
      Exit;

  Ay := y2 - y1;
  By := y3 - y4;

  if Ay < Zero then
    begin
      LowerY := y2;
      UpperY := y1;
    end
  else
    begin
      UpperY := y2;
      LowerY := y1;
    end;

  if By > Zero then
    begin
      if (UpperY < y4) or (y3 < LowerY) then
          Exit;
    end
  else if (UpperY < y3) or (y4 < LowerY) then
      Exit;

  Cx := x1 - x3;
  Cy := y1 - y3;
  d := (By * Cx) - (Bx * Cy);
  F := (Ay * Bx) - (Ax * By);

  if F > Zero then
    begin
      if (d < Zero) or (d > F) then
          Exit;
    end
  else if (d > Zero) or (d < F) then
      Exit;

  e := (Ax * Cy) - (Ay * Cx);

  if F > Zero then
    begin
      if (e < Zero) or (e > F) then
          Exit;
    end
  else if (e > Zero) or (e < F) then
      Exit;

  Result := True;
end;

function Intersect(const x1, y1, x2, y2, x3, y3, x4, y4: TGeoFloat; out ix, iy: TGeoFloat): Boolean;
var
  UpperX: TGeoFloat;
  UpperY: TGeoFloat;
  LowerX: TGeoFloat;
  LowerY: TGeoFloat;
  Ax    : TGeoFloat;
  Bx    : TGeoFloat;
  Cx    : TGeoFloat;
  Ay    : TGeoFloat;
  By    : TGeoFloat;
  Cy    : TGeoFloat;
  d     : TGeoFloat;
  F     : TGeoFloat;
  e     : TGeoFloat;
  Ratio : TGeoFloat;
begin
  Result := False;

  Ax := x2 - x1;
  Bx := x3 - x4;

  if Ax < Zero then
    begin
      LowerX := x2;
      UpperX := x1;
    end
  else
    begin
      UpperX := x2;
      LowerX := x1;
    end;

  if Bx > Zero then
    begin
      if (UpperX < x4) or (x3 < LowerX) then
          Exit;
    end
  else if (UpperX < x3) or (x4 < LowerX) then
      Exit;

  Ay := y2 - y1;
  By := y3 - y4;

  if Ay < Zero then
    begin
      LowerY := y2;
      UpperY := y1;
    end
  else
    begin
      UpperY := y2;
      LowerY := y1;
    end;

  if By > Zero then
    begin
      if (UpperY < y4) or (y3 < LowerY) then
          Exit;
    end
  else if (UpperY < y3) or (y4 < LowerY) then
      Exit;

  Cx := x1 - x3;
  Cy := y1 - y3;
  d := (By * Cx) - (Bx * Cy);
  F := (Ay * Bx) - (Ax * By);

  if F > Zero then
    begin
      if (d < Zero) or (d > F) then
          Exit;
    end
  else if (d > Zero) or (d < F) then
      Exit;

  e := (Ax * Cy) - (Ay * Cx);

  if F > Zero then
    begin
      if (e < Zero) or (e > F) then
          Exit;
    end
  else if (e > Zero) or (e < F) then
      Exit;

  Result := True;

  (*
    From IntersectionPoint Routine

    dx1 := x2 - x1; ->  Ax
    dx2 := x4 - x3; -> -Bx
    dx3 := x1 - x3; ->  Cx

    dy1 := y2 - y1; ->  Ay
    dy2 := y1 - y3; ->  Cy
    dy3 := y4 - y3; -> -By
  *)

  Ratio := (Ax * -By) - (Ay * -Bx);

  if NotEqual(Ratio, Zero) then
    begin
      Ratio := ((Cy * -Bx) - (Cx * -By)) / Ratio;
      ix := x1 + (Ratio * Ax);
      iy := y1 + (Ratio * Ay);
    end
  else
    begin
      if IsEqual((Ax * -Cy), (-Cx * Ay)) then
        begin
          ix := x3;
          iy := y3;
        end
      else
        begin
          ix := x4;
          iy := y4;
        end;
    end;
end;

function Intersect(const pt1, pt2, pt3, pt4: T2DPoint; out pt: T2DPoint): Boolean;
begin
  Result := Intersect(pt1[0], pt1[1], pt2[0], pt2[1], pt3[0], pt3[1], pt4[0], pt4[1], pt[0], pt[1]);
end;

function Intersect(const pt1, pt2, pt3, pt4: T2DPoint): Boolean;
begin
  Result := Intersect(pt1[0], pt1[1], pt2[0], pt2[1], pt3[0], pt3[1], pt4[0], pt4[1]);
end;

function PointInCircle(const pt, cp: T2DPoint; radius: TGeoFloat): Boolean;
begin
  Result := (PointLayDistance(pt, cp) <= (radius * radius));
end;

procedure ClosestPointOnSegmentFromPoint(const x1, y1, x2, y2, Px, Py: TGeoFloat; out Nx, Ny: TGeoFloat);
var
  Vx   : TGeoFloat;
  Vy   : TGeoFloat;
  Wx   : TGeoFloat;
  Wy   : TGeoFloat;
  c1   : TGeoFloat;
  c2   : TGeoFloat;
  Ratio: TGeoFloat;
begin
  Vx := x2 - x1;
  Vy := y2 - y1;
  Wx := Px - x1;
  Wy := Py - y1;

  c1 := Vx * Wx + Vy * Wy;

  if c1 <= 0.0 then
    begin
      Nx := x1;
      Ny := y1;
      Exit;
    end;

  c2 := Vx * Vx + Vy * Vy;

  if c2 <= c1 then
    begin
      Nx := x2;
      Ny := y2;
      Exit;
    end;

  Ratio := c1 / c2;

  Nx := x1 + Ratio * Vx;
  Ny := y1 + Ratio * Vy;
end;

function ClosestPointOnSegmentFromPoint(const lb, le, pt: T2DPoint): T2DPoint;
begin
  ClosestPointOnSegmentFromPoint(lb[0], lb[1], le[0], le[1], pt[0], pt[1], Result[0], Result[1]);
end;

function MinimumDistanceFromPointToLine(const Px, Py, x1, y1, x2, y2: TGeoFloat): TGeoFloat;
var
  Nx: TGeoFloat;
  Ny: TGeoFloat;
begin
  ClosestPointOnSegmentFromPoint(x1, y1, x2, y2, Px, Py, Nx, Ny);
  Result := Distance(Px, Py, Nx, Ny);
end;

function Quadrant(const angle: TGeoFloat): Integer;
begin
  Result := 0;
  if (angle >= 0.0) and (angle < 90.0) then
      Result := 1
  else if (angle >= 90.0) and (angle < 180.0) then
      Result := 2
  else if (angle >= 180.0) and (angle < 270.0) then
      Result := 3
  else if (angle >= 270.0) and (angle < 360.0) then
      Result := 4
  else if angle = 360.0 then
      Result := 1;
end;

procedure ProjectPoint(const Srcx, Srcy, Dstx, Dsty, Dist: TGeoFloat; out Nx, Ny: TGeoFloat);
var
  DistRatio: TGeoFloat;
begin
  DistRatio := Dist / Distance(Srcx, Srcy, Dstx, Dsty);
  Nx := Srcx + DistRatio * (Dstx - Srcx);
  Ny := Srcy + DistRatio * (Dsty - Srcy);
end;

procedure ProjectPoint(const Srcx, Srcy, Srcz, Dstx, Dsty, Dstz, Dist: TGeoFloat; out Nx, Ny, Nz: TGeoFloat);
var
  DistRatio: TGeoFloat;
begin
  DistRatio := Dist / Distance(Srcx, Srcy, Srcz, Dstx, Dsty, Dstz);
  Nx := Srcx + DistRatio * (Dstx - Srcx);
  Ny := Srcy + DistRatio * (Dsty - Srcy);
  Nz := Srcz + DistRatio * (Dstz - Srcz);
end;
(* End of Project Point 3D *)

procedure ProjectPoint(const Px, Py, angle, Distance: TGeoFloat; out Nx, Ny: TGeoFloat);
var
  dx: TGeoFloat;
  dy: TGeoFloat;
begin
  dx := Zero;
  dy := Zero;
  case Quadrant(angle) of
    1:
      begin
        dx := Cos(angle * PIDiv180) * Distance;
        dy := Sin(angle * PIDiv180) * Distance;
      end;
    2:
      begin
        dx := Sin((angle - 90.0) * PIDiv180) * Distance * -1.0;
        dy := Cos((angle - 90.0) * PIDiv180) * Distance;
      end;
    3:
      begin
        dx := Cos((angle - 180.0) * PIDiv180) * Distance * -1.0;
        dy := Sin((angle - 180.0) * PIDiv180) * Distance * -1.0;
      end;
    4:
      begin
        dx := Sin((angle - 270.0) * PIDiv180) * Distance;
        dy := Cos((angle - 270.0) * PIDiv180) * Distance * -1.0;
      end;
  end;
  Nx := Px + dx;
  Ny := Py + dy;
end;

procedure ProjectPoint0(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat);
begin
  Nx := Px + Distance;
  Ny := Py;
end;

procedure ProjectPoint45(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat);
begin
  Nx := Px + 0.70710678118654752440084436210485 * Distance;
  Ny := Py + 0.70710678118654752440084436210485 * Distance;
end;

procedure ProjectPoint90(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat);
begin
  Nx := Px;
  Ny := Py + Distance;
end;

procedure ProjectPoint135(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat);
begin
  Nx := Px - 0.70710678118654752440084436210485 * Distance;
  Ny := Py + 0.70710678118654752440084436210485 * Distance;
end;

procedure ProjectPoint180(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat);
begin
  Nx := Px - Distance;
  Ny := Py;
end;

procedure ProjectPoint225(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat);
begin
  Nx := Px - 0.70710678118654752440084436210485 * Distance;
  Ny := Py - 0.70710678118654752440084436210485 * Distance;
end;

procedure ProjectPoint270(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat);
begin
  Nx := Px;
  Ny := Py - Distance;
end;

procedure ProjectPoint315(const Px, Py, Distance: TGeoFloat; out Nx, Ny: TGeoFloat);
begin
  Nx := Px + 0.70710678118654752440084436210485 * Distance;
  Ny := Py - 0.70710678118654752440084436210485 * Distance;
end;

function ProjectPoint0(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint;
begin
  ProjectPoint0(Point[0], Point[1], Distance, Result[0], Result[1]);
end;

function ProjectPoint45(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint;
begin
  ProjectPoint45(Point[0], Point[1], Distance, Result[0], Result[1]);
end;

function ProjectPoint90(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint;
begin
  ProjectPoint90(Point[0], Point[1], Distance, Result[0], Result[1]);
end;

function ProjectPoint135(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint;
begin
  ProjectPoint135(Point[0], Point[1], Distance, Result[0], Result[1]);
end;

function ProjectPoint180(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint;
begin
  ProjectPoint180(Point[0], Point[1], Distance, Result[0], Result[1]);
end;

function ProjectPoint225(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint;
begin
  ProjectPoint225(Point[0], Point[1], Distance, Result[0], Result[1]);
end;

function ProjectPoint270(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint;
begin
  ProjectPoint270(Point[0], Point[1], Distance, Result[0], Result[1]);
end;

function ProjectPoint315(const Point: T2DPoint; const Distance: TGeoFloat): T2DPoint;
begin
  ProjectPoint315(Point[0], Point[1], Distance, Result[0], Result[1]);
end;

function GetCicleRadiusInPolyEndge(r: TGeoFloat; PolySlices: Integer): TGeoFloat;
begin
  Result := r / Sin((180 - 360 / PolySlices) * 0.5 / 180 * pi);
end;

procedure Circle2LineIntersectionPoint(const lb, le, cp: T2DPoint; const radius: TGeoFloat;
  out pt1in, pt2in: Boolean; out ICnt: Integer; out pt1, pt2: T2DPoint);
var
  Px  : TGeoFloat;
  Py  : TGeoFloat;
  S1In: Boolean;
  s2In: Boolean;
  h   : TGeoFloat;
  a   : TGeoFloat;
begin
  ICnt := 0;

  S1In := PointInCircle(lb, cp, radius);
  s2In := PointInCircle(le, cp, radius);

  if S1In and s2In then
    begin
      ICnt := 2;
      pt1 := lb;
      pt2 := le;
      pt1in := True;
      pt2in := True;
      Exit;
    end;

  if S1In or s2In then
    begin
      pt1in := True;
      pt2in := False;
      ICnt := 2;
      ClosestPointOnSegmentFromPoint(lb[0], lb[1], le[0], le[1], cp[0], cp[1], Px, Py);
      if S1In then
        begin
          h := Distance(Px, Py, cp[0], cp[1]);
          a := Sqrt((radius * radius) - (h * h));
          pt1 := lb;
          ProjectPoint(Px, Py, le[0], le[1], a, pt2[0], pt2[1]);
        end
      else if s2In then
        begin
          h := Distance(Px, Py, cp[0], cp[1]);
          a := Sqrt((radius * radius) - (h * h));
          pt1 := le;
          ProjectPoint(Px, Py, lb[0], lb[1], a, pt2[0], pt2[1]);
        end;
      Exit;
    end;

  pt1in := False;
  pt2in := False;

  ClosestPointOnSegmentFromPoint(lb[0], lb[1], le[0], le[1], cp[0], cp[1], Px, Py);

  if (IsEqual(lb[0], Px) and IsEqual(lb[1], Py)) or (IsEqual(le[0], Px) and IsEqual(le[1], Py)) then
      Exit
  else
    begin
      h := Distance(Px, Py, cp[0], cp[1]);
      if h > radius then
          Exit
      else if IsEqual(h, radius) then
        begin
          ICnt := 1;
          pt1[0] := Px;
          pt1[1] := Py;
          Exit;
        end
      else if IsEqual(h, Zero) then
        begin
          ICnt := 2;
          ProjectPoint(cp[0], cp[1], lb[0], lb[1], radius, pt1[0], pt1[1]);
          ProjectPoint(cp[0], cp[1], le[0], le[1], radius, pt2[0], pt2[1]);
          Exit;
        end
      else
        begin
          ICnt := 2;
          a := Sqrt((radius * radius) - (h * h));
          ProjectPoint(Px, Py, lb[0], lb[1], a, pt1[0], pt1[1]);
          ProjectPoint(Px, Py, le[0], le[1], a, pt2[0], pt2[1]);
          Exit;
        end;
    end;
end;

procedure Circle2CircleIntersectionPoint(const cp1, cp2: T2DPoint; const r1, r2: TGeoFloat; out Point1, Point2: T2DPoint);
var
  Dist  : TGeoFloat;
  a     : TGeoFloat;
  h     : TGeoFloat;
  RatioA: TGeoFloat;
  RatioH: TGeoFloat;
  dx    : TGeoFloat;
  dy    : TGeoFloat;
  Phi   : T2DPoint;
  r1Sqr : TGeoFloat;
  r2Sqr : TGeoFloat;
  dstSqr: TGeoFloat;
begin
  Dist := Distance(cp1[0], cp1[1], cp2[0], cp2[1]);

  dstSqr := Dist * Dist;
  r1Sqr := r1 * r1;
  r2Sqr := r2 * r2;

  a := (dstSqr - r2Sqr + r1Sqr) / (2 * Dist);
  h := Sqrt(r1Sqr - (a * a));

  RatioA := a / Dist;
  RatioH := h / Dist;

  dx := cp2[0] - cp1[0];
  dy := cp2[1] - cp1[1];

  Phi[0] := cp1[0] + (RatioA * dx);
  Phi[1] := cp1[1] + (RatioA * dy);

  dx := dx * RatioH;
  dy := dy * RatioH;

  Point1[0] := Phi[0] + dy;
  Point1[1] := Phi[1] - dx;

  Point2[0] := Phi[0] - dy;
  Point2[1] := Phi[1] + dx;
end;

function Check_Circle2Circle(const p1, p2: T2DPoint; const r1, r2: TGeoFloat): Boolean;
begin
  // return point disace < sum
  Result := PointDistance(p1, p2) <= r1 + r2;
end;

function CircleCollision(const p1, p2: T2DPoint; const r1, r2: TGeoFloat): Boolean;
begin
  // return point disace < sum
  Result := PointDistance(p1, p2) <= r1 + r2;
end;

function Check_Circle2CirclePoint(const p1, p2: T2DPoint; const r1, r2: TGeoFloat; out op1, op2: T2DPoint): Boolean;
var
  Dist  : TGeoFloat;
  a     : TGeoFloat;
  h     : TGeoFloat;
  RatioA: TGeoFloat;
  RatioH: TGeoFloat;
  dx    : TGeoFloat;
  dy    : TGeoFloat;
  Phi   : T2DPoint;
  r1Sqr : TGeoFloat;
  r2Sqr : TGeoFloat;
  dstSqr: TGeoFloat;
begin
  Dist := Distance(p1[0], p1[1], p2[0], p2[1]);
  Result := Dist <= r1 + r2;
  if Result then
    begin
      dstSqr := Dist * Dist;
      r1Sqr := r1 * r1;
      r2Sqr := r2 * r2;

      a := (dstSqr - r2Sqr + r1Sqr) / (2 * Dist);
      h := Sqrt(r1Sqr - (a * a));

      RatioA := a / Dist;
      RatioH := h / Dist;

      dx := p2[0] - p1[0];
      dy := p2[1] - p1[1];

      Phi[0] := p1[0] + (RatioA * dx);
      Phi[1] := p1[1] + (RatioA * dy);

      dx := dx * RatioH;
      dy := dy * RatioH;

      op1[0] := Phi[0] + dy;
      op1[1] := Phi[1] - dx;

      op2[0] := Phi[0] - dy;
      op2[1] := Phi[1] + dx;
    end;
end;

// circle 2 line collision

function Check_Circle2Line(const cp: T2DPoint; const r: TGeoFloat; const lb, le: T2DPoint): Boolean;
var
  lineCen, v1, v2: T2DPoint;
begin
  lineCen := PointLerp(lb, le, 0.5);
  if Check_Circle2Circle(cp, lineCen, r, PointDistance(lb, le) * 0.5) then
    begin
      v1 := PointSub(lb, cp);
      v2 := PointSub(le, cp);
      Result := GreaterThanOrEqual(((r * r) * PointLayDistance(v1, v2) - Sqr(v1[0] * v2[1] - v1[1] * v2[0])), Zero);
    end
  else
      Result := False;
end;

function T2DPointList.GetPoints(Index: Integer): P2DPoint;
begin
  Result := FList[index];
end;

constructor T2DPointList.Create;
begin
  inherited Create;
  FList := TCoreClassList.Create;
  FUserData := nil;
  FUserObject := nil;
end;

destructor T2DPointList.Destroy;
begin
  Clear;
  DisposeObject(FList);
  inherited Destroy;
end;

procedure T2DPointList.Add(X, Y: TGeoFloat);
var
  p: P2DPoint;
begin
  New(p);
  p^ := PointMake(X, Y);
  FList.Add(p);
end;

procedure T2DPointList.Add(pt: T2DPoint);
begin
  Add(pt[0], pt[1]);
end;

procedure T2DPointList.AddSubdivision(nbCount: Integer; pt: T2DPoint);
var
  lpt: P2DPoint;
  i  : Integer;
  t  : Double;
begin
  if Count > 0 then
    begin
      lpt := FList.Last;
      t := 1.0 / nbCount;
      for i := 1 to nbCount do
          Add(PointLerp(lpt^, pt, t * i));
    end
  else
      Add(pt);
end;

procedure T2DPointList.AddSubdivisionWithDistance(avgDist: TGeoFloat; pt: T2DPoint);
var
  lpt       : P2DPoint;
  i, nbCount: Integer;
  t         : Double;
begin
  if (Count > 0) and (PointDistance(P2DPoint(FList.Last)^, pt) > avgDist) then
    begin
      lpt := FList.Last;
      nbCount := Trunc(PointDistance(P2DPoint(FList.Last)^, pt) / avgDist);
      t := 1.0 / nbCount;
      for i := 1 to nbCount do
          Add(PointLerp(lpt^, pt, t * i));
    end;
  Add(pt);
end;

procedure T2DPointList.Insert(idx: Integer; X, Y: TGeoFloat);
var
  p: P2DPoint;
begin
  New(p);
  p^ := PointMake(X, Y);
  FList.Insert(idx, p);
end;

procedure T2DPointList.Delete(idx: Integer);
begin
  Dispose(P2DPoint(FList[idx]));
  FList.Delete(idx);
end;

procedure T2DPointList.Clear;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
      Dispose(P2DPoint(FList[i]));
  FList.Clear;
end;

function T2DPointList.Count: Integer;
begin
  Result := FList.Count;
end;

procedure T2DPointList.FixedSameError;
var
  l, p: P2DPoint;
  i   : Integer;
begin
  if Count < 2 then
      Exit;

  l := P2DPoint(FList[0]);
  p := P2DPoint(FList[Count - 1]);
  while (Count >= 2) and (IsEqual(p^, l^)) do
    begin
      Delete(Count - 1);
      p := P2DPoint(FList[Count - 1]);
    end;

  if Count < 2 then
      Exit;

  l := P2DPoint(FList[0]);
  i := 1;
  while i < Count do
    begin
      p := P2DPoint(FList[i]);
      if IsEqual(p^, l^) then
          Delete(i)
      else
        begin
          l := p;
          Inc(i);
        end;
    end;
end;

procedure T2DPointList.Assign(Source: TCoreClassPersistent);
var
  i: Integer;
begin
  if Source is T2DPointList then
    begin
      Clear;
      for i := 0 to T2DPointList(Source).Count - 1 do
          Add(T2DPointList(Source)[i]^);
    end
  else if Source is TPoly then
    begin
      Clear;
      for i := 0 to TPoly(Source).Count - 1 do
          Add(TPoly(Source).Points[i]);
    end;
end;

procedure T2DPointList.SaveToStream(Stream: TCoreClassStream);
var
  w: TDataWriter;
  i: Integer;
  p: P2DPoint;
begin
  w := TDataWriter.Create(Stream);
  w.writeInteger(Count);
  for i := 0 to Count - 1 do
    begin
      p := GetPoints(i);
      w.WriteSingle(p^[0]);
      w.WriteSingle(p^[1]);
    end;
  DisposeObject(w);
end;

procedure T2DPointList.LoadFromStream(Stream: TCoreClassStream);
var
  r: TDataReader;
  c: Integer;
  i: Integer;
begin
  Clear;
  r := TDataReader.Create(Stream);
  c := r.ReadInteger;
  for i := 0 to c - 1 do
      Add(r.ReadSingle, r.ReadSingle);
  DisposeObject(r);
end;

function T2DPointList.BoundRect: T2DRect;
var
  p   : P2DPoint;
  MaxX: TGeoFloat;
  MaxY: TGeoFloat;
  MinX: TGeoFloat;
  MinY: TGeoFloat;
  i   : Integer;
begin
  Result := Make2DRect(Zero, Zero, Zero, Zero);
  if Count < 2 then
      Exit;
  p := Items[0];
  MinX := p^[0];
  MaxX := p^[0];
  MinY := p^[1];
  MaxY := p^[1];

  for i := 1 to Count - 1 do
    begin
      p := Items[i];
      if p^[0] < MinX then
          MinX := p^[0]
      else if p^[0] > MaxX then
          MaxX := p^[0];
      if p^[1] < MinY then
          MinY := p^[1]
      else if p^[1] > MaxY then
          MaxY := p^[1];
    end;
  Result := Make2DRect(MinX, MinY, MaxX, MaxY);
end;

function T2DPointList.CircleRadius(ACentroid: T2DPoint): TGeoFloat;
var
  i      : Integer;
  LayLen : TGeoFloat;
  LayDist: TGeoFloat;
begin
  Result := 0;
  if Count < 3 then
      Exit;
  LayLen := -1;
  for i := 0 to Count - 1 do
    begin
      LayDist := PointLayDistance(ACentroid, Items[i]^);
      if LayDist > LayLen then
          LayLen := LayDist;
    end;
  Result := Sqrt(LayLen);
end;

function T2DPointList.Centroid: T2DPoint;
var
  i   : Integer;
  asum: TGeoFloat;
  term: TGeoFloat;

  p1, p2: P2DPoint;
begin
  Result := NULLPoint;

  if Count < 3 then
      Exit;

  asum := Zero;
  p2 := Items[Count - 1];

  for i := 0 to Count - 1 do
    begin
      p1 := Items[i];

      term := ((p2^[0] * p1^[1]) - (p2^[1] * p1^[0]));
      asum := asum + term;
      Result[0] := Result[0] + (p2^[0] + p1^[0]) * term;
      Result[1] := Result[1] + (p2^[1] + p1^[1]) * term;
      p2 := p1;
    end;

  if NotEqual(asum, Zero) then
    begin
      Result[0] := Result[0] / (3.0 * asum);
      Result[1] := Result[1] / (3.0 * asum);
    end;
end;

function T2DPointList.PointInHere(pt: T2DPoint): Boolean;
var
  i     : Integer;
  pi, pj: P2DPoint;
begin
  Result := False;
  if Count < 3 then
      Exit;
  pj := Items[Count - 1];
  for i := 0 to Count - 1 do
    begin
      pi := Items[i];
      if ((pi^[1] <= pt[1]) and (pt[1] < pj^[1])) or  // an upward crossing
        ((pj^[1] <= pt[1]) and (pt[1] < pi^[1])) then // a downward crossing
        begin
          (* compute the edge-ray intersect @ the x-coordinate *)
          if (pt[0] - pi^[0] < ((pj^[0] - pi^[0]) * (pt[1] - pi^[1]) / (pj^[1] - pi^[1]))) then
              Result := not Result;
        end;
      pj := pi;
    end;
end;

procedure T2DPointList.RotateAngle(axis: T2DPoint; angle: TGeoFloat);
var
  i: Integer;
  p: P2DPoint;
begin
  for i := 0 to Count - 1 do
    begin
      p := Items[i];
      p^ := PointRotation(axis, p^, PointAngle(axis, p^) + angle);
    end;
end;

procedure T2DPointList.Scale(axis: T2DPoint; Scale: TGeoFloat);
var
  i: Integer;
  p: P2DPoint;
begin
  for i := 0 to Count - 1 do
    begin
      p := Items[i];
      p^ := PointRotation(axis, PointDistance(axis, p^) * Scale, PointAngle(axis, p^));
    end;
end;

procedure T2DPointList.ConvexHull(output: T2DPointList);

const
  RightHandSide        = -1;
  LeftHandSide         = +1;
  CounterClockwise     = +1;
  CollinearOrientation = 0;

type
  T2DHullPoint = packed record
    X: TGeoFloat;
    Y: TGeoFloat;
    Ang: TGeoFloat;
  end;

  TCompareResult = (eGreaterThan, eLessThan, eEqual);

var
  Point            : array of T2DHullPoint;
  Stack            : array of T2DHullPoint;
  StackHeadPosition: Integer;
  Anchor           : T2DHullPoint;

  function CartesianAngle(const X, Y: TGeoFloat): TGeoFloat;
  const
    _180DivPI = 57.295779513082320876798154814105000;
  begin
    if (X > Zero) and (Y > Zero) then
        Result := (ArcTan(Y / X) * _180DivPI)
    else if (X < Zero) and (Y > Zero) then
        Result := (ArcTan(-X / Y) * _180DivPI) + 90.0
    else if (X < Zero) and (Y < Zero) then
        Result := (ArcTan(Y / X) * _180DivPI) + 180.0
    else if (X > Zero) and (Y < Zero) then
        Result := (ArcTan(-X / Y) * _180DivPI) + 270.0
    else if (X = Zero) and (Y > Zero) then
        Result := 90.0
    else if (X < Zero) and (Y = Zero) then
        Result := 180.0
    else if (X = Zero) and (Y < Zero) then
        Result := 270.0
    else
        Result := Zero;
  end;

  procedure Swap(i, j: Integer; var Point: array of T2DHullPoint);
  var
    temp: T2DHullPoint;
  begin
    temp := Point[i];
    Point[i] := Point[j];
    Point[j] := temp;
  end;

  function hEqual(const p1, p2: T2DHullPoint): Boolean;
  begin
    Result := IsEqual(p1.X, p2.X) and IsEqual(p1.Y, p2.Y);
  end;

  function CompareAngles(const p1, p2: T2DHullPoint): TCompareResult;
  begin
    if p1.Ang < p2.Ang then
        Result := eLessThan
    else if p1.Ang > p2.Ang then
        Result := eGreaterThan
    else if hEqual(p1, p2) then
        Result := eEqual
    else if Distance(Anchor.X, Anchor.Y, p1.X, p1.Y) < Distance(Anchor.X, Anchor.Y, p2.X, p2.Y) then
        Result := eLessThan
    else
        Result := eGreaterThan;
  end;

  procedure RQSort(Left, Right: Integer; var Point: array of T2DHullPoint);
  var
    i     : Integer;
    j     : Integer;
    Middle: Integer;
    Pivot : T2DHullPoint;
  begin
    repeat
      i := Left;
      j := Right;
      Middle := (Left + Right) div 2;
      (* Median of 3 Pivot Selection *)
      if CompareAngles(Point[Middle], Point[Left]) = eLessThan then
          Swap(Left, Middle, Point);
      if CompareAngles(Point[Right], Point[Middle]) = eLessThan then
          Swap(Right, Middle, Point);
      if CompareAngles(Point[Middle], Point[Left]) = eLessThan then
          Swap(Left, Middle, Point);
      Pivot := Point[Right];
      repeat
        while CompareAngles(Point[i], Pivot) = eLessThan do
            Inc(i);
        while CompareAngles(Point[j], Pivot) = eGreaterThan do
            Dec(j);
        if i <= j then
          begin
            Swap(i, j, Point);
            Inc(i);
            Dec(j);
          end;
      until i > j;
      if Left < j then
          RQSort(Left, j, Point);
      Left := i;
    until i >= Right;
  end;

  procedure Push(Pnt: T2DHullPoint);
  begin
    Inc(StackHeadPosition);
    Stack[StackHeadPosition] := Pnt;
  end;

  function Pop: Boolean;
  begin
    Result := False;
    if StackHeadPosition >= 0 then
      begin
        Result := True;
        Dec(StackHeadPosition);
      end;
  end;

  function Head: T2DHullPoint;
  begin
    Assert((StackHeadPosition >= 0) and (StackHeadPosition < Length(Stack)), 'Invalid stack-head position.');
    Result := Stack[StackHeadPosition];
  end;

  function PreHead: T2DHullPoint;
  begin
    Assert(((StackHeadPosition - 1) >= 0) and ((StackHeadPosition - 1) < Length(Stack)), 'Invalid pre stack-head position.');
    Result := Stack[StackHeadPosition - 1];
  end;

  function PreHeadExist: Boolean;
  begin
    Result := (StackHeadPosition > 0);
  end;

  function Orientation(p1, p2, p3: T2DHullPoint): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Orientation2(const x1, y1, x2, y2, Px, Py: TGeoFloat): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    var
      Orin: TGeoFloat;
    begin
      (* Determinant of the 3 points *)
      Orin := (x2 - x1) * (Py - y1) - (Px - x1) * (y2 - y1);
      if Orin > Zero then
          Result := LeftHandSide (* Orientaion is to the left-hand side *)
      else if Orin < Zero then
          Result := RightHandSide (* Orientaion is to the right-hand side *)
      else
          Result := CollinearOrientation; (* Orientaion is neutral aka collinear *)
    end;

  begin
    Result := Orientation2(p1.X, p1.Y, p2.X, p2.Y, p3.X, p3.Y);
  end;

  procedure GrahamScan;
  var
    i   : Integer;
    Orin: Integer;
  begin
    Push(Point[0]);
    Push(Point[1]);
    i := 2;
    while i < Length(Point) do
      begin
        if PreHeadExist then
          begin
            Orin := Orientation(PreHead, Head, Point[i]);
            if Orin = CounterClockwise then
              begin
                Push(Point[i]);
                Inc(i);
              end
            else
                Pop;
          end
        else
          begin
            Push(Point[i]);
            Inc(i);
          end;
      end;
  end;

var
  i: Integer;
  j: Integer;
  p: P2DPoint;
begin
  if Count <= 3 then
    begin
      for i := 0 to Count - 1 do
          output.Add(Items[i]^);
      Exit;
    end;
  StackHeadPosition := -1;

  try
    SetLength(Point, Count);
    SetLength(Stack, Count);
    j := 0;
    for i := 0 to Count - 1 do
      begin
        p := Items[i];
        Point[i].X := p^[0];
        Point[i].Y := p^[1];
        Point[i].Ang := 0.0;
        if Point[i].Y < Point[j].Y then
            j := i
        else if Point[i].Y = Point[j].Y then
          if Point[i].X < Point[j].X then
              j := i;
      end;

    Swap(0, j, Point);
    Point[0].Ang := 0;
    Anchor := Point[0];
    (* Calculate angle of the vertex ([ith point]-[anchorpoint]-[most left point]) *)
    for i := 1 to Length(Point) - 1 do
        Point[i].Ang := CartesianAngle(Point[i].X - Anchor.X, Point[i].Y - Anchor.Y);
    (* Sort points in ascending order according to their angles *)
    RQSort(1, Length(Point) - 1, Point);
    GrahamScan;
    (* output list *)
    for i := 0 to StackHeadPosition do
        output.Add(Stack[i].X, Stack[i].Y);
  finally
    (* Final clean-up *)
    Finalize(Stack);
    Finalize(Point);
  end;
end;

procedure T2DPointList.ExtractToBuff(var output: TArray2DPoint);
var
  i: Integer;
begin
  SetLength(output, Count);
  for i := 0 to Count - 1 do
      output[i] := Items[i]^;
end;

procedure T2DPointList.GiveListDataFromBuff(output: PArray2DPoint);
var
  i: Integer;
begin
  Clear;
  for i := low(output^) to high(output^) do
      Add(output^[i]);
end;

procedure T2DPointList.VertexReduction(Epsilon: TGeoFloat);
var
  Buff, output: TArray2DPoint;
begin
  ExtractToBuff(Buff);
  FastVertexReduction(Buff, Epsilon, output);
  GiveListDataFromBuff(@output);
end;

function T2DPointList.Line2Intersect(const lb, le: T2DPoint; ClosedPolyMode: Boolean; OutputPoint: T2DPointList): Boolean;
var
  i     : Integer;
  p1, p2: P2DPoint;
  ox, oy: TGeoFloat;
begin
  Result := False;
  if FList.Count > 1 then
    begin
      p1 := FList[0];
      for i := 1 to FList.Count - 1 do
        begin
          p2 := FList[i];
          if OutputPoint <> nil then
            begin
              if Intersect(lb[0], lb[1], le[0], le[1], p1^[0], p1^[1], p2^[0], p2^[1], ox, oy) then
                begin
                  OutputPoint.Add(ox, oy);
                  Result := True;
                end;
            end
          else
            begin
              if Intersect(lb[0], lb[1], le[0], le[1], p1^[0], p1^[1], p2^[0], p2^[1]) then
                  Result := True;
            end;
          p1 := p2;
        end;
      if ClosedPolyMode then
        begin
          p2 := FList[0];
          if OutputPoint <> nil then
            begin
              if Intersect(lb[0], lb[1], le[0], le[1], p1^[0], p1^[1], p2^[0], p2^[1], ox, oy) then
                begin
                  OutputPoint.Add(ox, oy);
                  Result := True;
                end;
            end
          else
            begin
              if Intersect(lb[0], lb[1], le[0], le[1], p1^[0], p1^[1], p2^[0], p2^[1]) then
                  Result := True;
            end;
        end;
    end;
end;

function T2DPointList.Line2NearIntersect(const lb, le: T2DPoint; const ClosedPolyMode: Boolean; out idx1, idx2: Integer; out IntersectPt: T2DPoint): Boolean;
var
  i     : Integer;
  p1, p2: P2DPoint;
  ox, oy: TGeoFloat;
  d, d2 : TGeoFloat;
begin
  Result := False;
  if FList.Count > 1 then
    begin
      p1 := FList[0];
      d := 0.0;
      for i := 1 to FList.Count - 1 do
        begin
          p2 := FList[i];
          if Intersect(lb[0], lb[1], le[0], le[1], p1^[0], p1^[1], p2^[0], p2^[1], ox, oy) then
            begin
              d2 := PointDistance(lb, PointMake(ox, oy));
              if (d = 0.0) or (d2 < d) then
                begin
                  IntersectPt := PointMake(ox, oy);
                  d := d2;
                  idx1 := i - 1;
                  idx2 := i;
                  Result := True;
                end;
            end;
          p1 := p2;
        end;
      if ClosedPolyMode then
        begin
          p2 := FList[0];
          if Intersect(lb[0], lb[1], le[0], le[1], p1^[0], p1^[1], p2^[0], p2^[1], ox, oy) then
            begin
              d2 := PointDistance(lb, PointMake(ox, oy));
              if (d = 0) or (d2 < d) then
                begin
                  IntersectPt := PointMake(ox, oy);
                  // d := d2;
                  idx1 := FList.Count - 1;
                  idx2 := 0;
                  Result := True;
                end;
            end;
        end;
    end;
end;

procedure T2DPointList.SortOfNear(const pt: T2DPoint);

  function ListSortCompare(Item1, Item2: Pointer): Integer;
  var
    d1, d2: TGeoFloat;
  begin
    d1 := PointDistance(P2DPoint(Item1)^, pt);
    d2 := PointDistance(P2DPoint(Item2)^, pt);
    Result := CompareValue(d1, d2);
  end;

  procedure QuickSortList(var SortList: TCoreClassPointerList; l, r: Integer); {$IFDEF INLINE_ASM} inline; {$ENDIF}
  var
    i, j: Integer;
    p, t: Pointer;
  begin
    repeat
      i := l;
      j := r;
      p := SortList[(l + r) shr 1];
      repeat
        while ListSortCompare(SortList[i], p) < 0 do
            Inc(i);
        while ListSortCompare(SortList[j], p) > 0 do
            Dec(j);
        if i <= j then
          begin
            if i <> j then
              begin
                t := SortList[i];
                SortList[i] := SortList[j];
                SortList[j] := t;
              end;
            Inc(i);
            Dec(j);
          end;
      until i > j;
      if l < j then
          QuickSortList(SortList, l, j);
      l := i;
    until i >= r;
  end;

begin
  if Count > 1 then
      QuickSortList(FList.ListData^, 0, Count - 1);
end;

procedure T2DPointList.SortOfFar(const pt: T2DPoint);

  function ListSortCompare(Item1, Item2: Pointer): Integer;
  var
    d1, d2: TGeoFloat;
  begin
    d1 := PointDistance(P2DPoint(Item1)^, pt);
    d2 := PointDistance(P2DPoint(Item2)^, pt);
    Result := CompareValue(d2, d1);
  end;

  procedure QuickSortList(var SortList: TCoreClassPointerList; l, r: Integer); {$IFDEF INLINE_ASM} inline; {$ENDIF}
  var
    i, j: Integer;
    p, t: Pointer;
  begin
    repeat
      i := l;
      j := r;
      p := SortList[(l + r) shr 1];
      repeat
        while ListSortCompare(SortList[i], p) < 0 do
            Inc(i);
        while ListSortCompare(SortList[j], p) > 0 do
            Dec(j);
        if i <= j then
          begin
            if i <> j then
              begin
                t := SortList[i];
                SortList[i] := SortList[j];
                SortList[j] := t;
              end;
            Inc(i);
            Dec(j);
          end;
      until i > j;
      if l < j then
          QuickSortList(SortList, l, j);
      l := i;
    until i >= r;
  end;

begin
  if Count > 1 then
      QuickSortList(FList.ListData^, 0, Count - 1);
end;

procedure T2DPointList.Reverse;
var
  NewList: TCoreClassList;
  i, c   : Integer;
begin
  NewList := TCoreClassList.Create;
  c := Count - 1;
  NewList.Count := c + 1;
  for i := c downto 0 do
      NewList[c - i] := FList[i];
  DisposeObject(FList);
  FList := NewList;
end;

procedure T2DPointList.AddCirclePoint(ACount: Cardinal; axis: T2DPoint; ADist: TGeoFloat);
var
  i: Integer;
begin
  for i := 0 to ACount - 1 do
      Add(PointRotation(axis, ADist, 360 / ACount * i));
end;

procedure T2DPointList.AddRectangle(r: T2DRect);
begin
  Add(r[0][0], r[0][1]);
  Add(r[1][0], r[0][1]);
  Add(r[1][0], r[1][1]);
  Add(r[0][0], r[1][1]);
end;

function T2DPointList.GetMinimumFromPointToLine(const pt: T2DPoint; const ClosedMode: Boolean; out lb, le: Integer): T2DPoint;
var
  i       : Integer;
  pt1, pt2: P2DPoint;
  opt     : T2DPoint;
  d, d2   : TGeoFloat;
begin
  if FList.Count > 1 then
    begin
      pt1 := Items[0];
      d := 0.0;
      for i := 1 to Count - 1 do
        begin
          pt2 := Items[i];

          opt := ClosestPointOnSegmentFromPoint(pt1^, pt2^, pt);

          d2 := PointDistance(pt, opt);
          if (d = 0.0) or (d2 < d) then
            begin
              Result := opt;
              d := d2;
              lb := i - 1;
              le := i;
            end;

          pt1 := pt2;
        end;
      if ClosedMode then
        begin
          pt2 := Items[0];
          opt := ClosestPointOnSegmentFromPoint(pt1^, pt2^, pt);
          d2 := PointDistance(pt, opt);
          if (d = 0.0) or (d2 < d) then
            begin
              Result := opt;
              lb := FList.Count - 1;
              le := 0;
            end;
        end;
    end
  else
    begin
      if Count = 1 then
        begin
          Result := Items[0]^;
          lb := 0;
          le := 0;
        end
      else
        begin
          Result := NULLPoint;
          lb := -1;
          le := -1;
        end;
    end;
end;

function T2DPointList.GetMinimumFromPointToLine(const pt: T2DPoint; const ClosedMode: Boolean): T2DPoint;
var
  i       : Integer;
  pt1, pt2: P2DPoint;
  opt     : T2DPoint;
  d, d2   : TGeoFloat;
begin
  if FList.Count > 1 then
    begin
      pt1 := Items[0];
      d := 0.0;
      for i := 1 to Count - 1 do
        begin
          pt2 := Items[i];

          opt := ClosestPointOnSegmentFromPoint(pt1^, pt2^, pt);

          d2 := PointDistance(pt, opt);
          if (d = 0.0) or (d2 < d) then
            begin
              Result := opt;
              d := d2;
            end;

          pt1 := pt2;
        end;
      if ClosedMode then
        begin
          pt2 := Items[0];
          opt := ClosestPointOnSegmentFromPoint(pt1^, pt2^, pt);
          d2 := PointDistance(pt, opt);
          if (d = 0.0) or (d2 < d) then
            begin
              Result := opt;
            end;
        end;
    end
  else
    begin
      if Count = 1 then
        begin
          Result := Items[0]^;
        end
      else
        begin
          Result := NULLPoint;
        end;
    end;
end;

function T2DPointList.GetMinimumFromPointToLine(const pt: T2DPoint; const ExpandDist: TGeoFloat): T2DPoint;
var
  i       : Integer;
  pt1, pt2: T2DPoint;
  opt     : T2DPoint;
  d, d2   : TGeoFloat;
begin
  if FList.Count > 1 then
    begin
      pt1 := Expands[0, ExpandDist];
      d := 0.0;
      for i := 1 to Count - 1 do
        begin
          pt2 := Expands[i, ExpandDist];

          opt := ClosestPointOnSegmentFromPoint(pt1, pt2, pt);

          d2 := PointDistance(pt, opt);
          if (d = 0.0) or (d2 < d) then
            begin
              Result := opt;
              d := d2;
            end;

          pt1 := pt2;
        end;

      pt2 := Expands[0, ExpandDist];
      opt := ClosestPointOnSegmentFromPoint(pt1, pt2, pt);
      d2 := PointDistance(pt, opt);
      if (d = 0.0) or (d2 < d) then
        begin
          Result := opt;
        end;
    end
  else
    begin
      if Count = 1 then
        begin
          Result := Items[0]^;
        end
      else
        begin
          Result := NULLPoint;
        end;
    end;
end;

procedure T2DPointList.CutLineBeginPtToIdx(const pt: T2DPoint; const toidx: Integer);
var
  i: Integer;
begin
  for i := 0 to toidx - 2 do
      Delete(0);
  Items[0]^ := pt;
end;

procedure T2DPointList.Translation(X, Y: TGeoFloat);
var
  i: Integer;
  p: P2DPoint;
begin
  for i := 0 to Count - 1 do
    begin
      p := Items[i];
      p^[0] := p^[0] + X;
      p^[1] := p^[1] + Y;
    end;
end;

procedure T2DPointList.Mul(X, Y: TGeoFloat);
var
  i: Integer;
  p: P2DPoint;
begin
  for i := 0 to Count - 1 do
    begin
      p := Items[i];
      p^[0] := p^[0] * X;
      p^[1] := p^[1] * Y;
    end;
end;

function T2DPointList.First: P2DPoint;
begin
  if Count > 0 then
      Result := Items[0]
  else
      Result := nil;
end;

function T2DPointList.Last: P2DPoint;
begin
  if Count > 0 then
      Result := Items[Count - 1]
  else
      Result := nil;
end;

procedure T2DPointList.ExpandDistanceAsList(ExpandDist: TGeoFloat; output: T2DPointList);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
      output.Add(GetExpands(i, ExpandDist));
end;

procedure T2DPointList.ExpandConvexHullAsList(ExpandDist: TGeoFloat; output: T2DPointList);
var
  pl: T2DPointList;
begin
  pl := T2DPointList.Create;
  ConvexHull(pl);
  pl.ExpandDistanceAsList(ExpandDist, output);
  DisposeObject(pl);
end;

function T2DPointList.GetExpands(idx: Integer; ExpandDist: TGeoFloat): T2DPoint;
var
  lpt, pt, rpt: T2DPoint;
  ln, rn      : T2DPoint;
  dx, dy, F, r: TGeoFloat;
  Cx, Cy      : TGeoFloat;
begin
  if (ExpandDist = 0) or (Count < 2) then
    begin
      Result := Items[idx]^;
      Exit;
    end;

  if idx > 0 then
      lpt := Items[idx - 1]^
  else
      lpt := Items[Count - 1]^;
  if idx + 1 < Count then
      rpt := Items[idx + 1]^
  else
      rpt := Items[0]^;
  pt := Items[idx]^;

  // normal : left to
  dx := (pt[0] - lpt[0]);
  dy := (pt[1] - lpt[1]);
  F := 1.0 / HypotX(dx, dy);
  ln[0] := (dy * F);
  ln[1] := -(dx * F);

  // normal : right to
  dx := (rpt[0] - pt[0]);
  dy := (rpt[1] - pt[1]);
  F := 1.0 / HypotX(dx, dy);
  rn[0] := (dy * F);
  rn[1] := -(dx * F);

  // compute the expand edge
  dx := (ln[0] + rn[0]);
  dy := (ln[1] + rn[1]);
  r := (ln[0] * dx) + (ln[1] * dy);
  if r = 0 then
      r := 1;
  Cx := (dx * ExpandDist / r);
  Cy := (dy * ExpandDist / r);

  Result[0] := pt[0] + Cx;
  Result[1] := pt[1] + Cy;
end;

function TPoly.GetPoly(Index: Integer): PPolyPoint;
begin
  Result := FList[index];
end;

constructor TPoly.Create;
begin
  inherited Create;
  FMaxRadius := 0;
  FList := TCoreClassList.Create;
  FPosition := PointMake(0, 0);
  FScale := 1.0;
  FAngle := 0;
  FExpandMode := emConvex;
  FUserDataObject := nil;
  FUserData := nil;
end;

destructor TPoly.Destroy;
begin
  Clear;
  DisposeObject(FList);
  inherited Destroy;
end;

procedure TPoly.Reset;
begin
  FPosition := PointMake(0, 0);
  FMaxRadius := 0;
  FScale := 1.0;
  FAngle := 0;
  Clear;
end;

procedure TPoly.Assign(Source: TCoreClassPersistent);
var
  i    : Integer;
  p, p2: PPolyPoint;
begin
  if Source is TPoly then
    begin
      Clear;

      FScale := TPoly(Source).FScale;
      FAngle := TPoly(Source).FAngle;
      FMaxRadius := TPoly(Source).FMaxRadius;
      FPosition := TPoly(Source).FPosition;
      FExpandMode := TPoly(Source).FExpandMode;

      for i := 0 to TPoly(Source).FList.Count - 1 do
        begin
          New(p);
          p2 := TPoly(Source).Poly[i];
          p^.Owner := Self;
          p^.angle := p2^.angle;
          p^.Dist := p2^.Dist;
          FList.Add(p);
        end;
    end
  else if Source is T2DPointList then
    begin
      RebuildPoly(T2DPointList(Source));
    end;
end;

procedure TPoly.AddPoint(pt: T2DPoint);
begin
  AddPoint(pt[0], pt[1]);
end;

procedure TPoly.AddPoint(X, Y: TGeoFloat);
var
  pt: T2DPoint;
begin
  pt := PointMake(X, Y);
  Add(PointAngle(FPosition, pt), PointDistance(FPosition, pt));
end;

procedure TPoly.Add(AAngle, ADist: TGeoFloat);
var
  p: PPolyPoint;
begin
  if ADist > FMaxRadius then
      FMaxRadius := ADist;
  New(p);
  p^.Owner := Self;
  p^.angle := AAngle - FAngle;
  p^.Dist := ADist / FScale;
  FList.Add(p);
end;

procedure TPoly.Insert(idx: Integer; angle, Dist: TGeoFloat);
var
  p: PPolyPoint;
begin
  New(p);
  p^.Owner := Self;
  p^.angle := angle;
  p^.Dist := Dist;
  FList.Insert(idx, p);
end;

procedure TPoly.Delete(idx: Integer);
begin
  Dispose(PPolyPoint(FList[idx]));
  FList.Delete(idx);
end;

procedure TPoly.Clear;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
      Dispose(PPolyPoint(FList[i]));
  FList.Clear;
end;

function TPoly.Count: Integer;
begin
  Result := FList.Count;
end;

procedure TPoly.CopyPoly(pl: TPoly; AReversed: Boolean);
  procedure _Append(a, d: TGeoFloat);
  var
    p: PPolyPoint;
  begin
    if d > FMaxRadius then
        FMaxRadius := d;
    New(p);
    p^.Owner := Self;
    p^.angle := a;
    p^.Dist := d;
    FList.Add(p);
  end;

var
  i: Integer;
begin
  Clear;
  FScale := pl.FScale;
  FAngle := pl.FAngle;
  FPosition := pl.FPosition;
  FMaxRadius := 0;
  if AReversed then
    begin
      for i := pl.Count - 1 downto 0 do
        with pl.Poly[i]^ do
            _Append(angle, Dist);
    end
  else
    begin
      for i := 0 to pl.Count - 1 do
        with pl.Poly[i]^ do
            _Append(angle, Dist);
    end;
end;

procedure TPoly.CopyExpandPoly(pl: TPoly; AReversed: Boolean; Dist: TGeoFloat);
var
  i: Integer;
begin
  Clear;
  FScale := pl.FScale;
  FAngle := pl.FAngle;
  FPosition := pl.FPosition;
  FMaxRadius := 0;
  if AReversed then
    begin
      for i := pl.Count - 1 downto 0 do
          AddPoint(pl.Expands[i, Dist]);
    end
  else
    for i := 0 to pl.Count - 1 do
        AddPoint(pl.Expands[i, Dist]);
end;

procedure TPoly.Reverse;
var
  NewList: TCoreClassList;
  i, c   : Integer;
begin
  NewList := TCoreClassList.Create;
  c := Count - 1;
  NewList.Count := c + 1;
  for i := c downto 0 do
      NewList[c - i] := FList[i];
  DisposeObject(FList);
  FList := NewList;
end;

function TPoly.ScaleBeforeDistance: TGeoFloat;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
      Result := Result + PPolyPoint(FList[i])^.Dist;
end;

function TPoly.ScaleAfterDistance: TGeoFloat;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
      Result := Result + PPolyPoint(FList[i])^.Dist * FScale;
end;

procedure TPoly.FixedSameError;
var
  l, p: PPolyPoint;
  i   : Integer;
begin
  if Count < 2 then
      Exit;

  l := PPolyPoint(FList[0]);
  p := PPolyPoint(FList[Count - 1]);
  while (Count >= 2) and (IsEqual(p^.angle, l^.angle)) and (IsEqual(p^.Dist, l^.Dist)) do
    begin
      Delete(Count - 1);
      p := PPolyPoint(FList[Count - 1]);
    end;

  if Count < 2 then
      Exit;

  l := PPolyPoint(FList[0]);
  i := 1;
  while i < Count do
    begin
      p := PPolyPoint(FList[i]);
      if (IsEqual(p^.angle, l^.angle)) and (IsEqual(p^.Dist, l^.Dist)) then
          Delete(i)
      else
        begin
          l := p;
          Inc(i);
        end;
    end;
end;

procedure TPoly.ConvexHullFromPoint(AFrom: T2DPointList);

const
  RightHandSide        = -1;
  LeftHandSide         = +1;
  CounterClockwise     = +1;
  CollinearOrientation = 0;

type
  T2DHullPoint = packed record
    X: TGeoFloat;
    Y: TGeoFloat;
    Ang: TGeoFloat;
  end;

  TCompareResult = (eGreaterThan, eLessThan, eEqual);

var
  Point            : array of T2DHullPoint;
  Stack            : array of T2DHullPoint;
  StackHeadPosition: Integer;
  Anchor           : T2DHullPoint;

  function CartesianAngle(const X, Y: TGeoFloat): TGeoFloat; {$IFDEF INLINE_ASM} inline; {$ENDIF}
  const
    _180DivPI = 57.295779513082320876798154814105000;
  begin
    if (X > Zero) and (Y > Zero) then
        Result := (ArcTan(Y / X) * _180DivPI)
    else if (X < Zero) and (Y > Zero) then
        Result := (ArcTan(-X / Y) * _180DivPI) + 90.0
    else if (X < Zero) and (Y < Zero) then
        Result := (ArcTan(Y / X) * _180DivPI) + 180.0
    else if (X > Zero) and (Y < Zero) then
        Result := (ArcTan(-X / Y) * _180DivPI) + 270.0
    else if (X = Zero) and (Y > Zero) then
        Result := 90.0
    else if (X < Zero) and (Y = Zero) then
        Result := 180.0
    else if (X = Zero) and (Y < Zero) then
        Result := 270.0
    else
        Result := Zero;
  end;

  procedure Swap(i, j: Integer; var Point: array of T2DHullPoint);
  var
    temp: T2DHullPoint;
  begin
    temp := Point[i];
    Point[i] := Point[j];
    Point[j] := temp;
  end;

  function CompareAngles(const p1, p2: T2DHullPoint): TCompareResult;
    function hEqual(const p1, p2: T2DHullPoint): Boolean; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    begin
      Result := IsEqual(p1.X, p2.X) and IsEqual(p1.Y, p2.Y);
    end;

  begin
    if p1.Ang < p2.Ang then
        Result := eLessThan
    else if p1.Ang > p2.Ang then
        Result := eGreaterThan
    else if hEqual(p1, p2) then
        Result := eEqual
    else if Distance(Anchor.X, Anchor.Y, p1.X, p1.Y) < Distance(Anchor.X, Anchor.Y, p2.X, p2.Y) then
        Result := eLessThan
    else
        Result := eGreaterThan;
  end;

  procedure RQSort(Left, Right: Integer; var Point: array of T2DHullPoint);
  var
    i     : Integer;
    j     : Integer;
    Middle: Integer;
    Pivot : T2DHullPoint;
  begin
    repeat
      i := Left;
      j := Right;
      Middle := (Left + Right) div 2;
      (* Median of 3 Pivot Selection *)
      if CompareAngles(Point[Middle], Point[Left]) = eLessThan then
          Swap(Left, Middle, Point);
      if CompareAngles(Point[Right], Point[Middle]) = eLessThan then
          Swap(Right, Middle, Point);
      if CompareAngles(Point[Middle], Point[Left]) = eLessThan then
          Swap(Left, Middle, Point);
      Pivot := Point[Right];
      repeat
        while CompareAngles(Point[i], Pivot) = eLessThan do
            Inc(i);
        while CompareAngles(Point[j], Pivot) = eGreaterThan do
            Dec(j);
        if i <= j then
          begin
            Swap(i, j, Point);
            Inc(i);
            Dec(j);
          end;
      until i > j;
      if Left < j then
          RQSort(Left, j, Point);
      Left := i;
    until i >= Right;
  end;

  procedure Push(Pnt: T2DHullPoint);
  begin
    Inc(StackHeadPosition);
    Stack[StackHeadPosition] := Pnt;
  end;

  function Pop: Boolean;
  begin
    Result := False;
    if StackHeadPosition >= 0 then
      begin
        Result := True;
        Dec(StackHeadPosition);
      end;
  end;

  function Head: T2DHullPoint;
  begin
    Assert((StackHeadPosition >= 0) and (StackHeadPosition < Length(Stack)), 'Invalid stack-head position.');
    Result := Stack[StackHeadPosition];
  end;

  function PreHead: T2DHullPoint;
  begin
    Assert(((StackHeadPosition - 1) >= 0) and ((StackHeadPosition - 1) < Length(Stack)), 'Invalid pre stack-head position.');
    Result := Stack[StackHeadPosition - 1];
  end;

  function PreHeadExist: Boolean;
  begin
    Result := (StackHeadPosition > 0);
  end;

  function Orientation(p1, p2, p3: T2DHullPoint): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    function Orientation2(const x1, y1, x2, y2, Px, Py: TGeoFloat): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
    var
      Orin: TGeoFloat;
    begin
      (* Determinant of the 3 points *)
      Orin := (x2 - x1) * (Py - y1) - (Px - x1) * (y2 - y1);
      if Orin > Zero then
          Result := LeftHandSide (* Orientaion is to the left-hand side *)
      else if Orin < Zero then
          Result := RightHandSide (* Orientaion is to the right-hand side *)
      else
          Result := CollinearOrientation; (* Orientaion is neutral aka collinear *)
    end;

  begin
    Result := Orientation2(p1.X, p1.Y, p2.X, p2.Y, p3.X, p3.Y);
  end;

  procedure GrahamScan;
  var
    i   : Integer;
    Orin: Integer;
  begin
    Push(Point[0]);
    Push(Point[1]);
    i := 2;
    while i < Length(Point) do
      begin
        if PreHeadExist then
          begin
            Orin := Orientation(PreHead, Head, Point[i]);
            if Orin = CounterClockwise then
              begin
                Push(Point[i]);
                Inc(i);
              end
            else
                Pop;
          end
        else
          begin
            Push(Point[i]);
            Inc(i);
          end;
      end;
  end;

  function CalcCentroid: T2DPoint;
  var
    i   : Integer;
    j   : Integer;
    asum: TGeoFloat;
    term: TGeoFloat;
  begin
    Result := NULLPoint;

    asum := Zero;
    j := StackHeadPosition;

    for i := 0 to StackHeadPosition do
      begin
        term := ((Stack[j].X * Stack[i].Y) - (Stack[j].Y * Stack[i].X));
        asum := asum + term;
        Result[0] := Result[0] + (Stack[j].X + Stack[i].X) * term;
        Result[1] := Result[1] + (Stack[j].Y + Stack[i].Y) * term;
        j := i;
      end;

    if NotEqual(asum, Zero) then
      begin
        Result[0] := Result[0] / (3.0 * asum);
        Result[1] := Result[1] / (3.0 * asum);
      end;
  end;

var
  i : Integer;
  j : Integer;
  pt: T2DPoint;
begin
  if AFrom.Count <= 3 then
      Exit;

  StackHeadPosition := -1;

  try
    SetLength(Point, AFrom.Count);
    SetLength(Stack, AFrom.Count);
    j := 0;
    for i := 0 to AFrom.Count - 1 do
      begin
        pt := AFrom[i]^;
        Point[i].X := pt[0];
        Point[i].Y := pt[1];
        Point[i].Ang := 0.0;
        if Point[i].Y < Point[j].Y then
            j := i
        else if Point[i].Y = Point[j].Y then
          if Point[i].X < Point[j].X then
              j := i;
      end;

    Swap(0, j, Point);
    Point[0].Ang := 0;
    Anchor := Point[0];
    (* Calculate angle of the vertex ([ith point]-[anchorpoint]-[most left point]) *)
    for i := 1 to Length(Point) - 1 do
        Point[i].Ang := CartesianAngle(Point[i].X - Anchor.X, Point[i].Y - Anchor.Y);
    (* Sort points in ascending order according to their angles *)
    RQSort(1, Length(Point) - 1, Point);
    GrahamScan;

    { * make Circle * }
    FPosition := CalcCentroid;
    FMaxRadius := 0;

    { * rebuild opt * }
    FScale := 1.0;
    FAngle := 0;

    { * clear * }
    Clear;

    (* output list to self *)
    for i := 0 to StackHeadPosition do
        AddPoint(Stack[i].X, Stack[i].Y);
  finally
    (* Final clean-up *)
    Finalize(Stack);
    Finalize(Point);
  end;
  RebuildPoly;
end;

procedure TPoly.RebuildPoly(pl: T2DPointList);
var
  i  : Integer;
  Ply: TPoly;
begin
  { * rebuild opt * }
  FPosition := pl.Centroid;
  FMaxRadius := 0;
  FScale := 1.0;
  FAngle := 0;

  { * rebuild poly * }
  Clear;
  for i := 0 to pl.Count - 1 do
      AddPoint(pl[i]^);

  Ply := TPoly.Create;
  with Ply do
    begin
      CopyExpandPoly(Self, False, 1);
      if (Self.FExpandMode = emConvex) and (Self.ScaleBeforeDistance > ScaleBeforeDistance) then
          Self.Reverse
      else if (Self.FExpandMode = emConcave) and (Self.ScaleBeforeDistance < ScaleBeforeDistance) then
          Self.Reverse;
    end;
  DisposeObject(Ply);
end;

procedure TPoly.RebuildPoly;
var
  pl: T2DPointList;
  i : Integer;
begin
  pl := T2DPointList.Create;
  for i := 0 to Count - 1 do
      pl.Add(GetPoint(i));
  RebuildPoly(pl);
  DisposeObject(pl);
end;

procedure TPoly.RebuildPoly(AScale, AAngle: TGeoFloat; AExpandMode: TExpandMode; APosition: T2DPoint);
var
  pl: T2DPointList;
  i : Integer;
begin
  pl := T2DPointList.Create;
  for i := 0 to Count - 1 do
      pl.Add(GetPoint(i));
  Scale := AScale;
  angle := AAngle;
  ExpandMode := AExpandMode;
  Position := APosition;
  RebuildPoly(pl);
  DisposeObject(pl);
end;

function TPoly.BoundRect: T2DRect;
var
  p   : T2DPoint;
  MaxX: TGeoFloat;
  MaxY: TGeoFloat;
  MinX: TGeoFloat;
  MinY: TGeoFloat;
  i   : Integer;
begin
  Result := Make2DRect(Zero, Zero, Zero, Zero);
  if Count < 2 then
      Exit;
  p := Points[0];
  MinX := p[0];
  MaxX := p[0];
  MinY := p[1];
  MaxY := p[1];

  for i := 1 to Count - 1 do
    begin
      p := Points[i];
      if p[0] < MinX then
          MinX := p[0]
      else if p[0] > MaxX then
          MaxX := p[0];
      if p[1] < MinY then
          MinY := p[1]
      else if p[1] > MaxY then
          MaxY := p[1];
    end;
  Result := Make2DRect(MinX, MinY, MaxX, MaxY);
end;

function TPoly.Centroid: T2DPoint;
var
  i   : Integer;
  asum: TGeoFloat;
  term: TGeoFloat;

  pt1, pt2: T2DPoint;
begin
  Result := NULLPoint;

  if Count < 3 then
      Exit;

  asum := Zero;
  pt2 := Points[Count - 1];

  for i := 0 to Count - 1 do
    begin
      pt1 := Points[i];

      term := ((pt2[0] * pt1[1]) - (pt2[1] * pt1[0]));
      asum := asum + term;
      Result[0] := Result[0] + (pt2[0] + pt1[0]) * term;
      Result[1] := Result[1] + (pt2[1] + pt1[1]) * term;
      pt2 := pt1;
    end;

  if NotEqual(asum, Zero) then
    begin
      Result[0] := Result[0] / (3.0 * asum);
      Result[1] := Result[1] / (3.0 * asum);
    end;
end;

function TPoly.PointInHere(pt: T2DPoint): Boolean;
var
  i     : Integer;
  pi, pj: T2DPoint;
begin
  Result := False;
  if Count < 3 then
      Exit;
  if not PointInCircle(pt, FPosition, FMaxRadius * FScale) then
      Exit;
  pj := GetPoint(Count - 1);
  for i := 0 to Count - 1 do
    begin
      pi := GetPoint(i);
      if ((pi[1] <= pt[1]) and (pt[1] < pj[1])) or  // an upward crossing
        ((pj[1] <= pt[1]) and (pt[1] < pi[1])) then // a downward crossing
        begin
          (* compute the edge-ray intersect @ the x-coordinate *)
          if (pt[0] - pi[0] < ((pj[0] - pi[0]) * (pt[1] - pi[1]) / (pj[1] - pi[1]))) then
              Result := not Result;
        end;
      pj := pi;
    end;
end;

function TPoly.LineNearIntersect(const lb, le: T2DPoint; const ClosedPolyMode: Boolean; out idx1, idx2: Integer; out IntersectPt: T2DPoint): Boolean;
var
  i       : Integer;
  pt1, pt2: T2DPoint;
  opt     : T2DPoint;
  d, d2   : TGeoFloat;
begin
  Result := False;
  if not Check_Circle2Line(FPosition, FMaxRadius * FScale, lb, le) then
      Exit;

  if FList.Count > 1 then
    begin
      pt1 := Points[0];
      d := 0.0;
      for i := 1 to Count - 1 do
        begin
          pt2 := Points[i];
          if Intersect(lb, le, pt1, pt2, opt) then
            begin
              d2 := PointDistance(lb, opt);
              if (d = 0.0) or (d2 < d) then
                begin
                  IntersectPt := opt;
                  d := d2;
                  idx1 := i - 1;
                  idx2 := i;
                  Result := True;
                end;
            end;
          pt1 := pt2;
        end;
      if ClosedPolyMode then
        begin
          pt2 := Points[0];
          if Intersect(lb, le, pt1, pt2, opt) then
            begin
              d2 := PointDistance(lb, opt);
              if (d = 0.0) or (d2 < d) then
                begin
                  IntersectPt := opt;
                  // d := d2;
                  idx1 := FList.Count - 1;
                  idx2 := 0;
                  Result := True;
                end;
            end;
        end;
    end;
end;

function TPoly.LineIntersect(const lb, le: T2DPoint; const ClosedPolyMode: Boolean): Boolean;
var
  i       : Integer;
  pt1, pt2: T2DPoint;
begin
  Result := False;
  if not Check_Circle2Line(FPosition, FMaxRadius * FScale, lb, le) then
      Exit;

  if FList.Count > 1 then
    begin
      pt1 := Points[0];
      for i := 1 to Count - 1 do
        begin
          pt2 := Points[i];
          if SimpleIntersect(lb, le, pt1, pt2) then
            begin
              Result := True;
              Exit;
            end;
          pt1 := pt2;
        end;
      if ClosedPolyMode then
        begin
          pt2 := Points[0];
          if SimpleIntersect(lb, le, pt1, pt2) then
              Result := True;
        end;
    end;
end;

function TPoly.GetMinimumFromPointToPoly(const pt: T2DPoint; const ClosedPolyMode: Boolean; out lb, le: Integer): T2DPoint;
var
  i       : Integer;
  pt1, pt2: T2DPoint;
  opt     : T2DPoint;
  d, d2   : TGeoFloat;
begin
  if FList.Count > 1 then
    begin
      pt1 := Points[0];
      d := 0.0;
      for i := 1 to Count - 1 do
        begin
          pt2 := Points[i];

          opt := ClosestPointOnSegmentFromPoint(pt1, pt2, pt);

          d2 := PointDistance(pt, opt);
          if (d = 0.0) or (d2 < d) then
            begin
              Result := opt;
              d := d2;
              lb := i - 1;
              le := i;
            end;

          pt1 := pt2;
        end;
      if ClosedPolyMode then
        begin
          pt2 := Points[0];
          opt := ClosestPointOnSegmentFromPoint(pt1, pt2, pt);
          d2 := PointDistance(pt, opt);
          if (d = 0.0) or (d2 < d) then
            begin
              Result := opt;
              lb := FList.Count - 1;
              le := 0;
            end;
        end;
    end
  else
    begin
      if Count = 1 then
        begin
          Result := Points[0];
          lb := 0;
          le := 0;
        end
      else
        begin
          Result := NULLPoint;
          lb := -1;
          le := -1;
        end;
    end;
end;

function TPoly.PointInHere(AExpandDistance: TGeoFloat; pt: T2DPoint): Boolean;
var
  i     : Integer;
  pi, pj: T2DPoint;
begin
  Result := False;
  if Count < 3 then
      Exit;
  if not PointInCircle(pt, FPosition, FMaxRadius * FScale + AExpandDistance) then
      Exit;
  pj := Expands[Count - 1, AExpandDistance];
  for i := 0 to Count - 1 do
    begin
      pi := Expands[i, AExpandDistance];
      if ((pi[1] <= pt[1]) and (pt[1] < pj[1])) or  // an upward crossing
        ((pj[1] <= pt[1]) and (pt[1] < pi[1])) then // a downward crossing
        begin
          (* compute the edge-ray intersect @ the x-coordinate *)
          if ((pt[0] - pi[0]) < ((pj[0] - pi[0]) * (pt[1] - pi[1]) / (pj[1] - pi[1]))) then
              Result := not Result;
        end;
      pj := pi;
    end;
end;

function TPoly.LineNearIntersect(AExpandDistance: TGeoFloat; const lb, le: T2DPoint; const ClosedPolyMode: Boolean; out idx1, idx2: Integer; out IntersectPt: T2DPoint): Boolean;
var
  i       : Integer;
  pt1, pt2: T2DPoint;
  opt     : T2DPoint;
  d, d2   : TGeoFloat;
begin
  Result := False;
  if not Check_Circle2Line(FPosition, FMaxRadius * FScale + AExpandDistance, lb, le) then
      Exit;

  if FList.Count > 1 then
    begin
      pt1 := Expands[0, AExpandDistance];
      d := 0.0;
      for i := 1 to Count - 1 do
        begin
          pt2 := Expands[i, AExpandDistance];
          if Intersect(lb, le, pt1, pt2, opt) then
            begin
              d2 := PointDistance(lb, opt);
              if (d = 0.0) or (d2 < d) then
                begin
                  IntersectPt := opt;
                  d := d2;
                  idx1 := i - 1;
                  idx2 := i;
                  Result := True;
                end;
            end;
          pt1 := pt2;
        end;
      if ClosedPolyMode then
        begin
          pt2 := Expands[0, AExpandDistance];
          if Intersect(lb, le, pt1, pt2, opt) then
            begin
              d2 := PointDistance(lb, opt);
              if (d = 0.0) or (d2 < d) then
                begin
                  IntersectPt := opt;
                  // d := d2;
                  idx1 := FList.Count - 1;
                  idx2 := 0;
                  Result := True;
                end;
            end;
        end;
    end;
end;

function TPoly.LineIntersect(AExpandDistance: TGeoFloat; const lb, le: T2DPoint; const ClosedPolyMode: Boolean): Boolean;
var
  i       : Integer;
  pt1, pt2: T2DPoint;
begin
  Result := False;
  if not Check_Circle2Line(FPosition, FMaxRadius * FScale + AExpandDistance, lb, le) then
      Exit;

  if FList.Count > 1 then
    begin
      pt1 := Expands[0, AExpandDistance];
      for i := 1 to Count - 1 do
        begin
          pt2 := Expands[i, AExpandDistance];
          if SimpleIntersect(lb, le, pt1, pt2) then
            begin
              Result := True;
              Exit;
            end;
          pt1 := pt2;
        end;
      if ClosedPolyMode then
        begin
          pt2 := Expands[0, AExpandDistance];
          if SimpleIntersect(lb, le, pt1, pt2) then
              Result := True;
        end;
    end;
end;

function TPoly.GetMinimumFromPointToPoly(AExpandDistance: TGeoFloat; const pt: T2DPoint; const ClosedPolyMode: Boolean; out lb, le: Integer): T2DPoint;
var
  i       : Integer;
  pt1, pt2: T2DPoint;
  opt     : T2DPoint;
  d, d2   : TGeoFloat;
begin
  if FList.Count > 1 then
    begin
      pt1 := Expands[0, AExpandDistance];
      d := 0.0;
      for i := 1 to Count - 1 do
        begin
          pt2 := Expands[i, AExpandDistance];
          opt := ClosestPointOnSegmentFromPoint(pt1, pt2, pt);
          d2 := PointDistance(pt, opt);
          if (d = 0.0) or (d2 < d) then
            begin
              Result := opt;
              d := d2;
              lb := i - 1;
              le := i;
            end;

          pt1 := pt2;
        end;
      if ClosedPolyMode then
        begin
          pt2 := Expands[0, AExpandDistance];
          opt := ClosestPointOnSegmentFromPoint(pt1, pt2, pt);
          d2 := PointDistance(pt, opt);
          if (d = 0.0) or (d2 < d) then
            begin
              Result := opt;
              lb := FList.Count - 1;
              le := 0;
            end;
        end;
    end
  else
    begin
      if Count = 1 then
        begin
          Result := Points[0];
          lb := 0;
          le := 0;
        end
      else
        begin
          Result := NULLPoint;
          lb := -1;
          le := -1;
        end;
    end;
end;

function TPoly.Collision2Circle(cp: T2DPoint; r: TGeoFloat; ClosedPolyMode: Boolean): Boolean;
var
  i            : Integer;
  curpt, destpt: T2DPoint;
begin
  if (Check_Circle2Circle(FPosition, cp, FMaxRadius * FScale, r)) and (Count > 0) then
    begin
      Result := True;
      curpt := Points[0];
      for i := 1 to Count - 1 do
        begin
          destpt := Points[i];
          if Check_Circle2Line(cp, r, curpt, destpt) then
              Exit;
          curpt := destpt;
        end;
      if ClosedPolyMode then
        if Check_Circle2Line(cp, r, curpt, Points[0]) then
            Exit;
    end;
  Result := False;
end;

function TPoly.Collision2Circle(cp: T2DPoint; r: TGeoFloat; ClosedPolyMode: Boolean; OutputLine: T2DLineList): Boolean;
var
  i            : Integer;
  curpt, destpt: T2DPoint;
begin
  Result := False;
  if (Check_Circle2Circle(FPosition, cp, FMaxRadius * FScale, r)) and (Count > 0) then
    begin
      curpt := Points[0];
      for i := 1 to Count - 1 do
        begin
          destpt := Points[i];
          if Check_Circle2Line(cp, r, curpt, destpt) then
            begin
              OutputLine.Add(curpt, destpt, i - 1, i, Self);
              Result := True;
            end;
          curpt := destpt;
        end;
      if ClosedPolyMode then
        if Check_Circle2Line(cp, r, curpt, Points[0]) then
          begin
            OutputLine.Add(curpt, Points[0], Count - 1, 0, Self);
            Result := True;
          end;
    end;
end;

function TPoly.Collision2Circle(AExpandDistance: TGeoFloat; cp: T2DPoint; r: TGeoFloat; ClosedPolyMode: Boolean; OutputLine: T2DLineList): Boolean;
var
  i            : Integer;
  curpt, destpt: T2DPoint;
begin
  Result := False;
  if (Check_Circle2Circle(FPosition, cp, FMaxRadius * FScale + AExpandDistance, r)) and (Count > 0) then
    begin
      curpt := Expands[0, AExpandDistance];
      for i := 1 to Count - 1 do
        begin
          destpt := Expands[i, AExpandDistance];
          if Check_Circle2Line(cp, r, curpt, destpt) then
            begin
              OutputLine.Add(curpt, destpt, i - 1, i, Self);
              Result := True;
            end;
          curpt := destpt;
        end;
      if ClosedPolyMode then
        if Check_Circle2Line(cp, r, curpt, Expands[0, AExpandDistance]) then
          begin
            OutputLine.Add(curpt, Expands[0, AExpandDistance], Count - 1, 0, Self);
            Result := True;
          end;
    end;
end;

function TPoly.PolyIntersect(APoly: TPoly): Boolean;
var
  i: Integer;
begin
  Result := Check_Circle2Circle(Position, APoly.Position, MaxRadius * FScale, APoly.MaxRadius * APoly.Scale);
  if not Result then
      Exit;

  for i := 0 to Count - 1 do
    if APoly.PointInHere(Points[i]) then
        Exit;

  for i := 0 to APoly.Count - 1 do
    if PointInHere(APoly.Points[i]) then
        Exit;

  Result := False;
end;

function TPoly.LerpToOfEndge(pt: T2DPoint; AProjDistance, AExpandDistance: TGeoFloat; FromIdx, toidx: Integer): T2DPoint;
  function NextIndexStep(CurIdx: Integer; curDir: ShortInt): Integer;
  begin
    if curDir < 0 then
      begin
        if CurIdx = 0 then
            Result := Count - 1
        else if CurIdx > 0 then
            Result := CurIdx - 1
        else
            Result := Count + CurIdx - 1;
      end
    else
      begin
        if CurIdx = Count - 1 then
            Result := 0
        else if CurIdx < Count - 1 then
            Result := CurIdx + 1
        else
            Result := CurIdx - Count;
      end;
    if (Result < 0) or (Result >= Count) then
        Result := -1;
  end;

var
  idxDir: ShortInt;
  ToPt  : T2DPoint;
  d     : TGeoFloat;
begin
  Result := pt;
  if Count <= 1 then
      Exit;

  if (FromIdx = Count - 1) and (toidx = 0) then
      idxDir := 1
  else if (FromIdx = 0) and (toidx = Count - 1) then
      idxDir := -1
  else if toidx < FromIdx then
      idxDir := -1
  else
      idxDir := 1;

  while True do
    begin
      ToPt := Expands[toidx, AExpandDistance];
      d := PointDistance(pt, ToPt);

      if AProjDistance < d then
        begin
          Result := PointLerpTo(pt, ToPt, AProjDistance);
          Exit;
        end;

      if d > 0 then
        begin
          pt := PointLerpTo(pt, ToPt, d);
          AProjDistance := AProjDistance - d;
        end;
      toidx := NextIndexStep(toidx, idxDir);
    end;
end;

function TPoly.GetPoint(idx: Integer): T2DPoint;
var
  p: PPolyPoint;
begin
  p := GetPoly(idx);
  Result := PointRotation(FPosition, p^.Dist * FScale, p^.angle + FAngle);
end;

procedure TPoly.SetPoint(idx: Integer; Value: T2DPoint);
var
  p: PPolyPoint;
begin
  p := GetPoly(idx);
  p^.angle := PointAngle(FPosition, Value) - FAngle;
  p^.Dist := PointDistance(FPosition, Value);
  if p^.Dist > FMaxRadius then
      FMaxRadius := p^.Dist;
  p^.Dist := p^.Dist / FScale;
end;

function TPoly.GetExpands(idx: Integer; ExpandDist: TGeoFloat): T2DPoint;
var
  lpt, pt, rpt: T2DPoint;
  ln, rn      : T2DPoint;
  dx, dy, F, r: TGeoFloat;
  Cx, Cy      : TGeoFloat;
begin
  if (ExpandDist = 0) or (Count < 2) then
    begin
      Result := Points[idx];
      Exit;
    end;

  if idx > 0 then
      lpt := Points[idx - 1]
  else
      lpt := Points[Count - 1];
  if idx + 1 < Count then
      rpt := Points[idx + 1]
  else
      rpt := Points[0];
  pt := Points[idx];

  // normal : left to
  dx := (pt[0] - lpt[0]);
  dy := (pt[1] - lpt[1]);
  F := 1.0 / HypotX(dx, dy);
  ln[0] := (dy * F);
  ln[1] := -(dx * F);

  // normal : right to
  dx := (rpt[0] - pt[0]);
  dy := (rpt[1] - pt[1]);
  F := 1.0 / HypotX(dx, dy);
  rn[0] := (dy * F);
  rn[1] := -(dx * F);

  // compute the expand edge
  dx := (ln[0] + rn[0]);
  dy := (ln[1] + rn[1]);
  r := (ln[0] * dx) + (ln[1] * dy);
  if r = 0 then
      r := 1;
  Cx := (dx * ExpandDist / r);
  Cy := (dy * ExpandDist / r);

  if FExpandMode = emConcave then
    begin
      Result[0] := pt[0] - Cx;
      Result[1] := pt[1] - Cy;
    end
  else
    begin
      Result[0] := pt[0] + Cx;
      Result[1] := pt[1] + Cy;
    end;
end;

procedure TPoly.SaveToStream(Stream: TCoreClassStream);
var
  w: TDataFrameEngine;
  i: Integer;
  p: PPolyPoint;
begin
  w := TDataFrameEngine.Create;
  w.WriteSingle(FScale);
  w.WriteSingle(FAngle);
  w.WriteSingle(FPosition[0]);
  w.WriteSingle(FPosition[1]);
  w.writeInteger(Count);
  for i := 0 to Count - 1 do
    begin
      p := GetPoly(i);
      w.WriteSingle(p^.angle);
      w.WriteSingle(p^.Dist);
    end;
  w.EncodeTo(Stream);
  DisposeObject(w);
end;

procedure TPoly.LoadFromStream(Stream: TCoreClassStream);
var
  r: TDataFrameEngine;
  c: Integer;
  i: Integer;
  procedure _Append(a, d: TGeoFloat);
  var
    p: PPolyPoint;
  begin
    if d > FMaxRadius then
        FMaxRadius := d;
    New(p);
    p^.Owner := Self;
    p^.angle := a;
    p^.Dist := d;
    FList.Add(p);
  end;

begin
  Clear;
  r := TDataFrameEngine.Create;
  r.DecodeFrom(Stream);
  FScale := r.Reader.ReadSingle;
  FAngle := r.Reader.ReadSingle;
  FPosition[0] := r.Reader.ReadSingle;
  FPosition[1] := r.Reader.ReadSingle;
  FMaxRadius := 0;
  c := r.Reader.ReadInteger;
  for i := 0 to c - 1 do
      _Append(r.Reader.ReadSingle, r.Reader.ReadSingle);
  DisposeObject(r);
end;

function T2DLineList.GetItems(Index: Integer): P2DLine;
begin
  Result := FList[index];
end;

constructor T2DLineList.Create;
begin
  inherited Create;
  FList := TCoreClassList.Create;
  FUserData := nil;
  FUserObject := nil;
end;

destructor T2DLineList.Destroy;
begin
  Clear;
  DisposeObject(FList);
  inherited Destroy;
end;

procedure T2DLineList.Assign(Source: TCoreClassPersistent);
var
  i: Integer;
begin
  if Source is T2DLineList then
    begin
      Clear;
      for i := 0 to T2DLineList(Source).Count - 1 do
          Add(T2DLineList(Source)[i]^);
    end;
end;

function T2DLineList.Add(v: T2DLine): Integer;
var
  p: P2DLine;
begin
  New(p);
  p^ := v;
  Result := FList.Add(p);
  p^.Index := Result;
end;

function T2DLineList.Add(lb, le: T2DPoint): Integer;
var
  p: P2DLine;
begin
  New(p);
  p^.Buff[0] := lb;
  p^.Buff[1] := le;
  p^.PolyIndex[0] := -1;
  p^.PolyIndex[1] := -1;
  p^.Poly := nil;
  Result := FList.Add(p);
  p^.Index := Result;
end;

function T2DLineList.Add(lb, le: T2DPoint; idx1, idx2: Integer; Poly: TPoly): Integer;
var
  p: P2DLine;
begin
  New(p);
  p^.Buff[0] := lb;
  p^.Buff[1] := le;
  p^.PolyIndex[0] := idx1;
  p^.PolyIndex[1] := idx2;
  p^.Poly := Poly;
  Result := FList.Add(p);
  p^.Index := Result;
end;

function T2DLineList.Count: Integer;
begin
  Result := FList.Count;
end;

procedure T2DLineList.Delete(Index: Integer);
var
  p: P2DLine;
  i: Integer;
begin
  p := FList[index];
  Dispose(p);
  FList.Delete(index);
  for i := index to Count - 1 do
      Items[i]^.Index := i;
end;

procedure T2DLineList.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
      Dispose(P2DLine(FList[i]));
  FList.Clear;
end;

function T2DLineList.NearLine(const ExpandDist: TGeoFloat; const pt: T2DPoint): P2DLine;
var
  d, d2: TGeoFloat;
  l    : P2DLine;
  i    : Integer;
begin
  Result := nil;
  if Count = 1 then
    begin
      Result := Items[0];
    end
  else if Count > 1 then
    begin
      l := Items[0];
      if ExpandDist = 0 then
          d := l^.MinimumDistance(pt)
      else
          d := l^.MinimumDistance(ExpandDist, pt);
      Result := l;

      for i := 1 to Count - 1 do
        begin
          l := Items[i];

          if ExpandDist = 0 then
              d2 := l^.MinimumDistance(pt)
          else
              d2 := l^.MinimumDistance(ExpandDist, pt);

          if d2 < d then
            begin
              Result := l;
              d := d2;
            end;
        end;
    end;
end;

function T2DLineList.FarLine(const ExpandDist: TGeoFloat; const pt: T2DPoint): P2DLine;
var
  d, d2: TGeoFloat;
  l    : P2DLine;
  i    : Integer;
begin
  Result := nil;
  if Count > 0 then
    begin
      l := Items[0];
      if ExpandDist = 0 then
          d := l^.MinimumDistance(pt)
      else
          d := l^.MinimumDistance(ExpandDist, pt);
      Result := l;

      for i := 1 to Count - 1 do
        begin
          l := Items[i];

          if ExpandDist = 0 then
              d2 := l^.MinimumDistance(pt)
          else
              d2 := l^.MinimumDistance(ExpandDist, pt);

          if d2 > d then
            begin
              Result := l;
              d := d2;
            end;
        end;
    end;
end;

procedure T2DLineList.SortOfNear(const pt: T2DPoint);

  function ListSortCompare(Item1, Item2: Pointer): Integer;
  var
    d1, d2: TGeoFloat;
  begin
    d1 := P2DLine(Item1)^.MinimumDistance(pt);
    d2 := P2DLine(Item2)^.MinimumDistance(pt);
    Result := CompareValue(d1, d2);
  end;

  procedure QuickSortList(var SortList: TCoreClassPointerList; l, r: Integer); {$IFDEF INLINE_ASM} inline; {$ENDIF}
  var
    i, j: Integer;
    p, t: Pointer;
  begin
    repeat
      i := l;
      j := r;
      p := SortList[(l + r) shr 1];
      repeat
        while ListSortCompare(SortList[i], p) < 0 do
            Inc(i);
        while ListSortCompare(SortList[j], p) > 0 do
            Dec(j);
        if i <= j then
          begin
            if i <> j then
              begin
                t := SortList[i];
                SortList[i] := SortList[j];
                SortList[j] := t;
              end;
            Inc(i);
            Dec(j);
          end;
      until i > j;
      if l < j then
          QuickSortList(SortList, l, j);
      l := i;
    until i >= r;
  end;

var
  i: Integer;
begin
  if Count > 1 then
      QuickSortList(FList.ListData^, 0, Count - 1);
  for i := 0 to Count - 1 do
      Items[i]^.Index := i;
end;

procedure T2DLineList.SortOfFar(const pt: T2DPoint);

  function ListSortCompare(Item1, Item2: Pointer): Integer;
  var
    d1, d2: TGeoFloat;
  begin
    d1 := P2DLine(Item1)^.MinimumDistance(pt);
    d2 := P2DLine(Item2)^.MinimumDistance(pt);
    Result := CompareValue(d2, d1);
  end;

  procedure QuickSortList(var SortList: TCoreClassPointerList; l, r: Integer);
  var
    i, j: Integer;
    p, t: Pointer;
  begin
    repeat
      i := l;
      j := r;
      p := SortList[(l + r) shr 1];
      repeat
        while ListSortCompare(SortList[i], p) < 0 do
            Inc(i);
        while ListSortCompare(SortList[j], p) > 0 do
            Dec(j);
        if i <= j then
          begin
            if i <> j then
              begin
                t := SortList[i];
                SortList[i] := SortList[j];
                SortList[j] := t;
              end;
            Inc(i);
            Dec(j);
          end;
      until i > j;
      if l < j then
          QuickSortList(SortList, l, j);
      l := i;
    until i >= r;
  end;

var
  i: Integer;
begin
  if Count > 1 then
      QuickSortList(FList.ListData^, 0, Count - 1);
  for i := 0 to Count - 1 do
      Items[i]^.Index := i;
end;

function T2DCircleList.GetItems(Index: Integer): P2DCircle;
begin
  Result := FList[index];
end;

constructor T2DCircleList.Create;
begin
  inherited Create;
  FList := TCoreClassList.Create;
end;

destructor T2DCircleList.Destroy;
begin
  Clear;
  DisposeObject(FList);
  inherited Destroy;
end;

procedure T2DCircleList.Assign(Source: TCoreClassPersistent);
var
  i: Integer;
begin
  if Source is T2DCircleList then
    begin
      Clear;
      for i := 0 to T2DCircleList(Source).Count - 1 do
          Add(T2DCircleList(Source)[i]^);
    end;
end;

function T2DCircleList.Add(const v: T2DCircle): Integer;
var
  p: P2DCircle;
begin
  New(p);
  p^ := v;
  Result := FList.Add(p);
end;

function T2DCircleList.Add(const Position: T2DPoint; const radius: TGeoFloat; const UserData: TCoreClassObject): Integer;
var
  p: P2DCircle;
begin
  New(p);
  p^.Position := Position;
  p^.radius := radius;
  p^.UserData := UserData;
  Result := FList.Add(p);
end;

function T2DCircleList.Count: Integer;
begin
  Result := FList.Count;
end;

procedure T2DCircleList.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
      Dispose(P2DCircle(FList[i]));
  FList.Clear;
end;

procedure T2DCircleList.Delete(Index: Integer);
var
  p: P2DCircle;
begin
  p := FList[index];
  Dispose(p);
  FList.Delete(index);
end;

procedure T2DCircleList.SortOfMinRadius;

  function ListSortCompare(Item1, Item2: Pointer): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
  var
    d1, d2: TGeoFloat;
  begin
    d1 := P2DCircle(Item1)^.radius;
    d2 := P2DCircle(Item2)^.radius;
    Result := CompareValue(d1, d2);
  end;

  procedure QuickSortList(var SortList: TCoreClassPointerList; l, r: Integer); {$IFDEF INLINE_ASM} inline; {$ENDIF}
  var
    i, j: Integer;
    p, t: Pointer;
  begin
    repeat
      i := l;
      j := r;
      p := SortList[(l + r) shr 1];
      repeat
        while ListSortCompare(SortList[i], p) < 0 do
            Inc(i);
        while ListSortCompare(SortList[j], p) > 0 do
            Dec(j);
        if i <= j then
          begin
            if i <> j then
              begin
                t := SortList[i];
                SortList[i] := SortList[j];
                SortList[j] := t;
              end;
            Inc(i);
            Dec(j);
          end;
      until i > j;
      if l < j then
          QuickSortList(SortList, l, j);
      l := i;
    until i >= r;
  end;

begin
  if Count > 1 then
      QuickSortList(FList.ListData^, 0, Count - 1);
end;

procedure T2DCircleList.SortOfMaxRadius;

  function ListSortCompare(Item1, Item2: Pointer): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
  var
    d1, d2: TGeoFloat;
  begin
    d1 := P2DCircle(Item1)^.radius;
    d2 := P2DCircle(Item2)^.radius;
    Result := CompareValue(d2, d1);
  end;

  procedure QuickSortList(var SortList: TCoreClassPointerList; l, r: Integer); {$IFDEF INLINE_ASM} inline; {$ENDIF}
  var
    i, j: Integer;
    p, t: Pointer;
  begin
    repeat
      i := l;
      j := r;
      p := SortList[(l + r) shr 1];
      repeat
        while ListSortCompare(SortList[i], p) < 0 do
            Inc(i);
        while ListSortCompare(SortList[j], p) > 0 do
            Dec(j);
        if i <= j then
          begin
            if i <> j then
              begin
                t := SortList[i];
                SortList[i] := SortList[j];
                SortList[j] := t;
              end;
            Inc(i);
            Dec(j);
          end;
      until i > j;
      if l < j then
          QuickSortList(SortList, l, j);
      l := i;
    until i >= r;
  end;

begin
  if Count > 1 then
      QuickSortList(FList.ListData^, 0, Count - 1);
end;

function T2DRectList.GetItems(Index: Integer): P2DRect;
begin
  Result := FList[index];
end;

constructor T2DRectList.Create;
begin
  inherited Create;
  FList := TCoreClassList.Create;
end;

destructor T2DRectList.Destroy;
begin
  Clear;
  DisposeObject(FList);
  inherited Destroy;
end;

procedure T2DRectList.Assign(Source: TCoreClassPersistent);
var
  i: Integer;
begin
  if Source is T2DRectList then
    begin
      Clear;
      for i := 0 to T2DRectList(Source).Count - 1 do
          Add(T2DRectList(Source)[i]^);
    end;
end;

function T2DRectList.Add(const v: T2DRect): Integer;
var
  p: P2DRect;
begin
  New(p);
  p^ := v;
  Result := FList.Add(p);
end;

function T2DRectList.Count: Integer;
begin
  Result := FList.Count;
end;

procedure T2DRectList.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
      Dispose(P2DRect(FList[i]));
  FList.Clear;
end;

procedure T2DRectList.Delete(Index: Integer);
var
  p: P2DRect;
begin
  p := FList[index];
  Dispose(p);
  FList.Delete(index);
end;

function TPolyRect.IsZero: Boolean;
begin
  Result :=
    Geometry2DUnit.IsZero(LeftTop) and
    Geometry2DUnit.IsZero(RightTop) and
    Geometry2DUnit.IsZero(RightBottom) and
    Geometry2DUnit.IsZero(LeftBottom);
end;

function TPolyRect.Rotation(angle: TGeoFloat): TPolyRect;
var
  axis: T2DPoint;
begin
  axis := Centroid;
  Result.LeftTop := PointRotation(axis, LeftTop, PointAngle(axis, LeftTop) + angle);
  Result.RightTop := PointRotation(axis, RightTop, PointAngle(axis, RightTop) + angle);
  Result.RightBottom := PointRotation(axis, RightBottom, PointAngle(axis, RightBottom) + angle);
  Result.LeftBottom := PointRotation(axis, LeftBottom, PointAngle(axis, LeftBottom) + angle);
end;

function TPolyRect.Rotation(axis: T2DPoint; angle: TGeoFloat): TPolyRect;
begin
  Result.LeftTop := PointRotation(axis, LeftTop, PointAngle(axis, LeftTop) + angle);
  Result.RightTop := PointRotation(axis, RightTop, PointAngle(axis, RightTop) + angle);
  Result.RightBottom := PointRotation(axis, RightBottom, PointAngle(axis, RightBottom) + angle);
  Result.LeftBottom := PointRotation(axis, LeftBottom, PointAngle(axis, LeftBottom) + angle);
end;

function TPolyRect.Add(v: T2DPoint): TPolyRect;
begin
  Result.LeftTop := PointAdd(LeftTop, v);
  Result.RightTop := PointAdd(RightTop, v);
  Result.RightBottom := PointAdd(RightBottom, v);
  Result.LeftBottom := PointAdd(LeftBottom, v);
end;

function TPolyRect.Sub(v: T2DPoint): TPolyRect;
begin
  Result.LeftTop := PointSub(LeftTop, v);
  Result.RightTop := PointSub(RightTop, v);
  Result.RightBottom := PointSub(RightBottom, v);
  Result.LeftBottom := PointSub(LeftBottom, v);
end;

function TPolyRect.Mul(v: T2DPoint): TPolyRect;
begin
  Result.LeftTop := PointMul(LeftTop, v);
  Result.RightTop := PointMul(RightTop, v);
  Result.RightBottom := PointMul(RightBottom, v);
  Result.LeftBottom := PointMul(LeftBottom, v);
end;

function TPolyRect.MoveTo(Position: T2DPoint): TPolyRect;
begin
  Result := Init(Position, PointDistance(LeftTop, RightTop), PointDistance(LeftBottom, RightBottom), 0);
end;

function TPolyRect.BoundRect: T2DRect;
begin
  Result := Geometry2DUnit.BoundRect(LeftTop, RightTop, RightBottom, LeftBottom);
end;

function TPolyRect.BoundRectf: TRectf;
begin
  Result := MakeRectf(BoundRect);
end;

function TPolyRect.Centroid: T2DPoint;
begin
  Result := Geometry2DUnit.BuffCentroid(LeftTop, RightTop, RightBottom, LeftBottom);
end;

class function TPolyRect.Init(r: T2DRect; Ang: TGeoFloat): TPolyRect;
var
  axis: T2DPoint;
begin
  with Result do
    begin
      LeftTop := PointMake(r[0][0], r[0][1]);
      RightTop := PointMake(r[1][0], r[0][1]);
      RightBottom := PointMake(r[1][0], r[1][1]);
      LeftBottom := PointMake(r[0][0], r[1][1]);
    end;
  if Ang <> 0 then
      Result := Result.Rotation(Ang);
end;

class function TPolyRect.Init(r: TRectf; Ang: TGeoFloat): TPolyRect;
begin
  Result := Init(Make2DRect(r), Ang);
end;

class function TPolyRect.Init(r: TRect; Ang: TGeoFloat): TPolyRect;
begin
  Result := Init(Make2DRect(r), Ang);
end;

class function TPolyRect.Init(CenPos: T2DPoint; width, height, Ang: TGeoFloat): TPolyRect;
var
  r: T2DRect;
begin
  r[0][0] := CenPos[0] - width * 0.5;
  r[0][1] := CenPos[1] - height * 0.5;
  r[1][0] := CenPos[0] + width * 0.5;
  r[1][1] := CenPos[1] + height * 0.5;
  Result := Init(r, Ang);
end;

class function TPolyRect.Init(width, height, Ang: TGeoFloat): TPolyRect;
begin
  Result := Init(Make2DRect(0, 0, width, height), Ang);
end;

class function TPolyRect.InitZero: TPolyRect;
begin
  with Result do
    begin
      LeftTop := NULLPoint;
      RightTop := NULLPoint;
      RightBottom := NULLPoint;
      LeftBottom := NULLPoint;
    end;
end;

function TRectPacking.Pack(width, height: TGeoFloat; var X, Y: TGeoFloat): Boolean;
var
  i   : Integer;
  p   : PRectPackData;
  r, b: TGeoFloat;
begin
  MaxWidth := Max(MaxWidth, width);
  MaxHeight := Max(MaxHeight, height);

  i := 0;
  while i < FList.Count do
    begin
      p := FList[i];
      if (width <= RectWidth(p^.rect)) and (height <= RectHeight(p^.rect)) then
        begin
          FList.Delete(i);
          X := p^.rect[0][0];
          Y := p^.rect[0][1];
          r := X + width;
          b := Y + height;
          MaxWidth := Max(MaxWidth, Max(width, r));
          MaxHeight := Max(MaxHeight, Max(height, b));
          Add(X, b, width, p^.rect[1][1] - b);
          Add(r, Y, p^.rect[1][0] - r, height);
          Add(r, b, p^.rect[1][0] - r, p^.rect[1][1] - b);
          Result := True;
          Dispose(p);
          Exit;
        end;
      Inc(i);
    end;
  X := 0;
  Y := 0;
  Result := False;
end;

function TRectPacking.GetItems(const Index: Integer): PRectPackData;
begin
  Result := PRectPackData(FList[index]);
end;

constructor TRectPacking.Create;
begin
  inherited Create;
  FList := TCoreClassList.Create;
  MaxWidth := 0;
  MaxHeight := 0;
end;

destructor TRectPacking.Destroy;
begin
  Clear;
  DisposeObject(FList);
  inherited;
end;

procedure TRectPacking.Clear;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
      Dispose(PRectPackData(FList[i]));
  FList.Clear;
end;

function TRectPacking.Count: Integer;
begin
  Result := FList.Count;
end;

procedure TRectPacking.Add(const X, Y, width, height: TGeoFloat);
var
  p: PRectPackData;
begin
  New(p);
  p^.rect := FixRect(Make2DRect(X, Y, X + width, Y + height));
  p^.error := True;
  p^.Data1 := nil;
  p^.Data2 := nil;
  FList.Add(p);
end;

procedure TRectPacking.Add(Data1: Pointer; Data2: TCoreClassObject; X, Y, width, height: TGeoFloat);
var
  p: PRectPackData;
begin
  New(p);
  p^.rect := FixRect(Make2DRect(0, 0, width, height));
  p^.error := True;
  p^.Data1 := Data1;
  p^.Data2 := Data2;
  FList.Add(p);
end;

procedure TRectPacking.Add(Data1: Pointer; Data2: TCoreClassObject; r: T2DRect);
begin
  Add(Data1, Data2, 0, 0, RectWidth(r), RectHeight(r));
end;

function TRectPacking.Data1Exists(const Data1: Pointer): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to FList.Count - 1 do
    if (PRectPackData(FList[i])^.Data1 = Data1) then
        Exit;
  Result := False;
end;

function TRectPacking.Data2Exists(const Data2: TCoreClassObject): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to FList.Count - 1 do
    if (PRectPackData(FList[i])^.Data2 = Data2) then
        Exit;
  Result := False;
end;

procedure TRectPacking.Build(SpaceWidth, SpaceHeight: TGeoFloat);

  function ListSortCompare(Left, Right: Pointer): Integer; {$IFDEF INLINE_ASM} inline; {$ENDIF}
  begin
    Result := CompareValue(RectArea(PRectPackData(Right)^.rect), RectArea(PRectPackData(Left)^.rect));
  end;

  procedure QuickSortList(var SortList: TCoreClassPointerList; l, r: Integer); {$IFDEF INLINE_ASM} inline; {$ENDIF}
  var
    i, j: Integer;
    p, t: Pointer;
  begin
    repeat
      i := l;
      j := r;
      p := SortList[(l + r) shr 1];
      repeat
        while ListSortCompare(SortList[i], p) < 0 do
            Inc(i);
        while ListSortCompare(SortList[j], p) > 0 do
            Dec(j);
        if i <= j then
          begin
            if i <> j then
              begin
                t := SortList[i];
                SortList[i] := SortList[j];
                SortList[j] := t;
              end;
            Inc(i);
            Dec(j);
          end;
      until i > j;
      if l < j then
          QuickSortList(SortList, l, j);
      l := i;
    until i >= r;
  end;

var
  newLst    : TRectPacking;
  p         : PRectPackData;
  i         : Integer;
  X, Y, w, h: TGeoFloat;
begin
  if FList.Count > 1 then
      QuickSortList(FList.ListData^, 0, Count - 1);

  newLst := TRectPacking.Create;
  newLst.Add(0, 0, SpaceWidth, SpaceHeight);
  for i := 0 to FList.Count - 1 do
    begin
      p := FList[i];

      X := p^.rect[0][0];
      Y := p^.rect[0][1];

      w := RectWidth(p^.rect);
      h := RectHeight(p^.rect);

      p^.error := not newLst.Pack(w + 2, h + 2, X, Y);

      if not p^.error then
          p^.rect := Make2DRect(X, Y, X + w, Y + h);
    end;

  MaxWidth := newLst.MaxWidth;
  MaxHeight := newLst.MaxHeight;

  DisposeObject(newLst);
end;

initialization

SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);

finalization

end.
