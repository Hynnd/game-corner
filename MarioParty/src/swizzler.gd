class_name Swizzler
# Vector swizzler

# Vector2 ---------------------------------------------------
static func ox(vec) -> Vector2:
	return Vector2(0, vec.x)

static func oy(vec) -> Vector2:
	return Vector2(0, vec.y)

static func oz(vec: Vector3) -> Vector2:
	return Vector2(0, vec.z)

static func xo(vec) -> Vector2:
	return Vector2(vec.x, 0)

static func xy(vec) -> Vector2:
	return Vector2(vec.x, vec.y)

static func xz(vec: Vector3) -> Vector2:
	return Vector2(vec.x, vec.z)

static func yo(vec) -> Vector2:
	return Vector2(vec.y, 0)

static func yx(vec) -> Vector2:
	return Vector2(vec.y, vec.x)

static func yz(vec: Vector3) -> Vector2:
	return Vector2(vec.y, vec.z)

static func zo(vec: Vector3) -> Vector2:
	return Vector2(vec.z, 0)

static func zx(vec: Vector3) -> Vector2:
	return Vector2(vec.z, vec.x)

static func zy(vec: Vector3) -> Vector2:
	return Vector2(vec.z, vec.y)

# Vector3 ---------------------------------------------------
static func xxx(vec) -> Vector3:
	return Vector3(vec.x, vec.x, vec.x)

static func xxy(vec) -> Vector3:
	return Vector3(vec.x, vec.x, vec.y)

static func xxz(vec: Vector3) -> Vector3:
	return Vector3(vec.x, vec.x, vec.z)

static func xxo(vec) -> Vector3:
	return Vector3(vec.x, vec.x, 0)

static func xyy(vec) -> Vector3:
	return Vector3(vec.x, vec.y, vec.y)

static func xzy(vec) -> Vector3:
	return Vector3(vec.x, vec.z, vec.y)

static func xyz(vec: Vector3) -> Vector3:
	return Vector3(vec.x, vec.y, vec.z)

static func xzz(vec: Vector3) -> Vector3:
	return Vector3(vec.x, vec.z, vec.z)

static func xoo(vec) -> Vector3:
	return Vector3(vec.x, 0, 0)

static func xoy(vec) -> Vector3:
	return Vector3(vec.x, 0, vec.y)

static func xzo(vec: Vector3) -> Vector3:
	return Vector3(vec.x, vec.z, 0)

static func yyx(vec) -> Vector3:
	return Vector3(vec.y, vec.y, vec.x)

static func yyz(vec: Vector3) -> Vector3:
	return Vector3(vec.y, vec.y, vec.z)

static func yyy(vec) -> Vector3:
	return Vector3(vec.y, vec.y, vec.y)

static func yox(vec) -> Vector3:
	return Vector3(vec.y, 0, vec.x)

static func yoz(vec: Vector3) -> Vector3:
	return Vector3(vec.y, 0, vec.z)

static func yoo(vec) -> Vector3:
	return Vector3(vec.y, 0, 0)

static func zxx(vec: Vector3) -> Vector3:
	return Vector3(vec.z, vec.x, vec.x)

static func zxy(vec: Vector3) -> Vector3:
	return Vector3(vec.z, vec.x, vec.y)

static func zyy(vec: Vector3) -> Vector3:
	return Vector3(vec.z, vec.y, vec.y)

static func zzz(vec: Vector3) -> Vector3:
	return Vector3(vec.z, vec.z, vec.z)

static func zox(vec: Vector3) -> Vector3:
	return Vector3(vec.z, 0, vec.x)

static func zoy(vec: Vector3) -> Vector3:
	return Vector3(vec.z, 0, vec.y)

static func zzo(vec: Vector3) -> Vector3:
	return Vector3(vec.z, vec.z, 0)

static func zoo(vec: Vector3) -> Vector3:
	return Vector3(vec.z, 0, 0)

static func oxx(vec) -> Vector3:
	return Vector3(0, vec.x, vec.x)

static func oxy(vec) -> Vector3:
	return Vector3(0, vec.x, vec.y)

static func oxz(vec: Vector3) -> Vector3:
	return Vector3(0, vec.x, vec.y)

static func oyx(vec) -> Vector3:
	return Vector3(0, vec.y, vec.x)

static func oyy(vec) -> Vector3:
	return Vector3(0, vec.y, vec.y)

static func oyz(vec: Vector3) -> Vector3:
	return Vector3(0, vec.y, vec.z)

static func ozo(vec: Vector3) -> Vector3:
	return Vector3(0, vec.z, 0)

static func ozx(vec: Vector3) -> Vector3:
	return Vector3(0, vec.z, vec.x)

static func ozy(vec: Vector3) -> Vector3:
	return Vector3(0, vec.z, vec.y)

static func ooz(vec: Vector3) -> Vector3:
	return Vector3(0, 0, vec.z)

static func xoz(vec: Vector3) -> Vector3:
	return Vector3(vec.x, 0, vec.z)

static func xyo(vec) -> Vector3:
	return Vector3(vec.x, vec.y, 0)

static func oyo(vec) -> Vector3:
	return Vector3(0, vec.y, 0)

# floats
static func foo(number) -> Vector3:
	return Vector3(number, 0, 0)

static func ofo(number) -> Vector3:
	return Vector3(0, number, 0)

static func oof(number) -> Vector3:
	return Vector3(0, 0, number)

static func fff(number) -> Vector3:
	return Vector3(number, number, number)

static func ffo(number) -> Vector3:
	return Vector3(number, number, 0)

static func fof(number) -> Vector3:
	return Vector3(number, 0, number)

static func off(number) -> Vector3:
	return Vector3(0, number, number)
